import os
import uuid
from typing import List
from uuid import UUID

from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    status,
    UploadFile,
    File
)
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from database.models import (
    User,
    UserAchievement,
    UserGameStat, Achievement
)
from database.session_maker import get_session
from schemas.achievements_schemas import (
    UserAchievementDTO,
    UpdateUserAchievementDTO,
    AddUserAchievementDTO
)
from schemas.game_schemas import (
    UpdateUserGameStatDTO,
    UserGameStatDTO,
    AddUserGameStatDTO
)
from schemas.token import Token
from schemas.user_schemas import (
    UserDTO,
    AddUserDTO,
    UpdateUserDTO
)
from utils.auth import create_access_token, get_current_user
from utils.password_utils import hash_password, verify_password

router = APIRouter(prefix="/user", tags=["User"])


# Вспомогательная функция для генерации токена для заданного пользователя
async def generate_token_for_user(user: User) -> Token:
    user_data = UserDTO.from_orm(user).dict()
    user_data["id"] = str(user_data["id"])

    token = create_access_token(
        data={"sub": user.email, "user_id": str(user.id), "user": user_data}
    )
    return Token(access_token=token, token_type="bearer", user=user_data)


@router.post("/login", response_model=Token)
async def login_user(
        form_data: OAuth2PasswordRequestForm = Depends(),
        session: AsyncSession = Depends(get_session)
):
    # По умолчанию form_data.username содержит email
    stmt = select(User).where(User.email == form_data.username)
    user = (await session.scalars(stmt)).first()

    if not user or not verify_password(form_data.password, user.password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email or password is incorrect"
        )

    return await generate_token_for_user(user)


# -----------------------------------------------------
# 1. Создание пользователя
# -----------------------------------------------------
@router.post("/add", response_model=Token, status_code=status.HTTP_201_CREATED)
async def add_user(
        user_in: AddUserDTO,
        session: AsyncSession = Depends(get_session)
) -> Token:
    """
    Создаёт нового пользователя, хеширует пароль и сразу генерирует JWT-токен,
    что позволяет сразу "залогиниться". При этом создаются статистики по играм и
    записи достижений для нового пользователя.
    """
    # Проверка на существование пользователя с таким email
    stmt = select(User).where(User.email == user_in.email)
    existing = (await session.scalars(stmt)).first()
    if existing:
        raise HTTPException(
            status_code=400,
            detail="User with this email already exists"
        )

    # Хеширование пароля и создание нового пользователя
    hashed_pwd = hash_password(user_in.password)
    new_user = User(
        name=user_in.name,
        email=user_in.email,
        password=hashed_pwd
    )
    session.add(new_user)
    await session.commit()
    await session.refresh(new_user)

    # Создаем статистику для игр (например, для game_id от 1 до 9)
    for game_id in range(1, 10):
        new_stat = UserGameStat(
            user_id=new_user.id,
            game_id=game_id,
            high_score=0,
            games_played=0,
            stats={}
        )
        session.add(new_stat)

    # Создаем записи для достижений пользователя.
    # Предполагается, что достижения уже есть в таблице Achievement.
    stmt = select(Achievement)
    achievements = (await session.scalars(stmt)).all()
    for achievement in achievements:
        new_user_achievement = UserAchievement(
            user_id=new_user.id,
            achievement_id=achievement.id,
            achieved=False,
            progress=0
        )
        session.add(new_user_achievement)

    await session.commit()

    # Сразу генерируем токен как при логине
    return await generate_token_for_user(new_user)


# -----------------------------------------------------
# 2. Список пользователей (требует валидный токен)
# -----------------------------------------------------
@router.get("/get", response_model=List[UserDTO])
async def get_all_users(
        session: AsyncSession = Depends(get_session),
        current_user: User = Depends(get_current_user)
) -> List[UserDTO]:
    """
    Возвращает список всех пользователей.
    """
    stmt = select(User)
    users = (await session.scalars(stmt)).all()
    return [UserDTO.from_orm(u) for u in users]


# -----------------------------------------------------
# 3. Получить пользователя по ID (требует токен)
# -----------------------------------------------------
@router.get("/get/{user_id}", response_model=UserDTO)
async def get_user_by_id(
        user_id: UUID,
        session: AsyncSession = Depends(get_session),
        current_user: User = Depends(get_current_user)
) -> UserDTO:
    """
    Получить пользователя по ID. Если не найден, 404.
    """
    stmt = select(User).where(User.id == user_id)
    user = (await session.scalars(stmt)).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return UserDTO.from_orm(user)


# -----------------------------------------------------
# 4. Частичное обновление полей (требует токен)
# -----------------------------------------------------
@router.patch("/update/{user_id}", response_model=UserDTO)
async def update_user(
        user_id: UUID,
        update_data: UpdateUserDTO,
        session: AsyncSession = Depends(get_session),
        current_user: User = Depends(get_current_user)
) -> UserDTO:
    """
    Частичное обновление пользователя (имя, email, experience).
    """
    stmt = select(User).where(User.id == user_id)
    user = (await session.scalars(stmt)).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    if update_data.name is not None:
        user.name = update_data.name

    if update_data.email is not None:
        check_stmt = select(User).where(
            User.email == update_data.email,
            User.id != user_id
        )
        duplicate = (await session.scalars(check_stmt)).first()
        if duplicate:
            raise HTTPException(
                status_code=400,
                detail="Another user with this email already exists"
            )
        user.email = update_data.email

    if update_data.experience is not None:
        user.experience = update_data.experience

    await session.commit()
    await session.refresh(user)
    return UserDTO.from_orm(user)


# -----------------------------------------------------
# 5. Удаление пользователя (требует токен)
# -----------------------------------------------------
@router.delete("/delete/{user_id}")
async def delete_user(
        user_id: UUID,
        session: AsyncSession = Depends(get_session),
        current_user: User = Depends(get_current_user)
) -> dict:
    """
    Удалить пользователя по ID.
    """
    stmt = select(User).where(User.id == user_id)
    user = (await session.scalars(stmt)).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    await session.delete(user)
    await session.commit()
    return {"detail": "User deleted"}


# -----------------------------------------------------
# 6. Загрузка / обновление аватара (требует токен)
# -----------------------------------------------------
AVATAR_DIR = "media/avatars"


@router.post("/{user_id}/avatar", response_model=UserDTO)
async def upload_user_avatar(
        user_id: UUID,
        file: UploadFile = File(...),
        session: AsyncSession = Depends(get_session),
        current_user: User = Depends(get_current_user)
) -> UserDTO:
    """
    Загрузка или обновление аватара пользователя.
    """
    stmt = select(User).where(User.id == user_id)
    user = (await session.scalars(stmt)).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    ext = os.path.splitext(file.filename)[1]
    unique_name = f"avatar-{uuid.uuid4()}{ext}"
    save_path = os.path.join(AVATAR_DIR, unique_name)

    os.makedirs(AVATAR_DIR, exist_ok=True)
    if user.avatar_url is not None:
        os.remove(user.avatar_url)

    contents = await file.read()
    with open(save_path, "wb") as f:
        f.write(contents)

    user.avatar_url = f"media/avatars/{unique_name}"
    await session.commit()
    await session.refresh(user)
    return UserDTO.from_orm(user)


# -----------------------------------------------------
# 7. Работа с достижениями пользователя (требует токен)
# -----------------------------------------------------
@router.get("/{user_id}/achievements", response_model=List[UserAchievementDTO])
async def list_user_achievements(
        user_id: UUID,
        session: AsyncSession = Depends(get_session),
        current_user: User = Depends(get_current_user)
) -> List[UserAchievementDTO]:
    """
    Возвращает список всех достижений для данного пользователя.
    """
    stmt = select(UserAchievement).where(UserAchievement.user_id == user_id)
    records = (await session.scalars(stmt)).all()
    return records


@router.get("/{user_id}/achievements/{achievement_id}", response_model=UserAchievementDTO)
async def get_user_achievement(
        user_id: UUID,
        achievement_id: int,
        session: AsyncSession = Depends(get_session),
        current_user: User = Depends(get_current_user)
) -> UserAchievementDTO:
    """
    Возвращает одну запись user_achievement по ключам (user_id, achievement_id).
    """
    stmt = select(UserAchievement).where(
        UserAchievement.user_id == user_id,
        UserAchievement.achievement_id == achievement_id
    )
    record = (await session.scalars(stmt)).first()
    if not record:
        raise HTTPException(status_code=404, detail="UserAchievement not found")
    return record


@router.post("/{user_id}/achievements", response_model=UserAchievementDTO, status_code=status.HTTP_201_CREATED)
async def create_user_achievement(
        user_id: UUID,
        data: AddUserAchievementDTO,
        session: AsyncSession = Depends(get_session),
        current_user: User = Depends(get_current_user)
) -> UserAchievementDTO:
    """
    Создаёт новую запись user_achievement.
    """
    stmt_check = select(UserAchievement).where(
        UserAchievement.user_id == user_id,
        UserAchievement.achievement_id == data.achievement_id
    )
    existing = (await session.scalars(stmt_check)).first()
    if existing:
        raise HTTPException(status_code=400, detail="UserAchievement already exists")

    new_record = UserAchievement(
        user_id=user_id,
        achievement_id=data.achievement_id,
        achieved=data.achieved,
        progress=data.progress
    )
    session.add(new_record)
    await session.commit()
    await session.refresh(new_record)
    return new_record


@router.patch("/{user_id}/achievements/{achievement_id}", response_model=UserAchievementDTO)
async def update_user_achievement(
        user_id: UUID,
        achievement_id: int,
        update_data: UpdateUserAchievementDTO,
        session: AsyncSession = Depends(get_session),
        current_user: User = Depends(get_current_user)
) -> UserAchievementDTO:
    """
    Частично обновляет запись user_achievement (achieved, progress).
    Автоматически устанавливает achieved, если progress достигает max_progress.
    """
    stmt = select(UserAchievement).where(
        UserAchievement.user_id == user_id,
        UserAchievement.achievement_id == achievement_id
    )
    record = (await session.scalars(stmt)).first()
    if not record:
        raise HTTPException(status_code=404, detail="UserAchievement not found")

    # Если приходит обновление прогресса, проверяем его значение
    if update_data.progress is not None:
        new_progress = update_data.progress
        # Получаем данные о достижении из таблицы Achievement
        achievement_stmt = select(Achievement).where(Achievement.id == achievement_id)
        achievement_record = (await session.scalars(achievement_stmt)).first()
        if achievement_record:
            if new_progress >= achievement_record.max_progress:
                # Если прогресс достиг максимума, устанавливаем achieved и фиксируем значение
                record.progress = achievement_record.max_progress
                record.achieved = True
            else:
                record.progress = new_progress

    # Если явно передается поле achieved, его можно обработать, но основная логика определяется прогрессом
    if update_data.achieved is not None:
        record.achieved = update_data.achieved

    await session.commit()
    await session.refresh(record)
    return record


@router.delete("/{user_id}/achievements/{achievement_id}")
async def delete_user_achievement(
        user_id: UUID,
        achievement_id: int,
        session: AsyncSession = Depends(get_session),
        current_user: User = Depends(get_current_user)
) -> dict:
    """
    Удаляет запись user_achievement.
    """
    stmt = select(UserAchievement).where(
        UserAchievement.user_id == user_id,
        UserAchievement.achievement_id == achievement_id
    )
    record = (await session.scalars(stmt)).first()
    if not record:
        raise HTTPException(status_code=404, detail="UserAchievement not found")

    await session.delete(record)
    await session.commit()
    return {"detail": "UserAchievement deleted"}


# -----------------------------------------------------
# 8. Работа со статистикой пользователя (требует токен)
# -----------------------------------------------------
@router.get("/{user_id}/stats", response_model=List[UserGameStatDTO])
async def list_user_stats(
        user_id: UUID,
        session: AsyncSession = Depends(get_session),
        current_user: User = Depends(get_current_user)
) -> List[UserGameStatDTO]:
    """
    Возвращает список статистики для пользователя.
    """
    stmt = select(UserGameStat).where(UserGameStat.user_id == user_id)
    records = (await session.scalars(stmt)).all()
    return records


@router.get("/{user_id}/stats/{game_id}", response_model=UserGameStatDTO)
async def get_user_stat_for_game(
        user_id: UUID,
        game_id: int,
        session: AsyncSession = Depends(get_session),
        current_user: User = Depends(get_current_user)
) -> UserGameStatDTO:
    """
    Получить статистику для конкретной игры.
    """
    stmt = select(UserGameStat).where(
        UserGameStat.user_id == user_id,
        UserGameStat.game_id == game_id
    )
    record = (await session.scalars(stmt)).first()
    if not record:
        raise HTTPException(status_code=404, detail="UserGameStat not found")
    return record


@router.post("/{user_id}/stats", response_model=UserGameStatDTO, status_code=status.HTTP_201_CREATED)
async def create_user_stat(
        user_id: UUID,
        data: AddUserGameStatDTO,
        session: AsyncSession = Depends(get_session),
        current_user: User = Depends(get_current_user)
) -> UserGameStatDTO:
    """
    Создаёт новую запись user_game_stats.
    """
    stmt_check = select(UserGameStat).where(
        UserGameStat.user_id == user_id,
        UserGameStat.game_id == data.game_id
    )
    existing = (await session.scalars(stmt_check)).first()
    if existing:
        raise HTTPException(status_code=400, detail="UserGameStat already exists")

    new_record = UserGameStat(
        user_id=user_id,
        game_id=data.game_id,
        high_score=data.high_score,
        games_played=data.games_played
    )
    session.add(new_record)
    await session.commit()
    await session.refresh(new_record)
    return new_record


@router.patch("/{user_id}/stats/{game_id}", response_model=UserGameStatDTO)
async def update_user_stat(
        user_id: UUID,
        game_id: int,
        update_data: UpdateUserGameStatDTO,
        session: AsyncSession = Depends(get_session),
        current_user: User = Depends(get_current_user)
) -> UserGameStatDTO:
    """
    Частично обновляет статистику (high_score, games_played).
    """
    stmt = select(UserGameStat).where(
        UserGameStat.user_id == user_id,
        UserGameStat.game_id == game_id
    )
    record = (await session.scalars(stmt)).first()
    if not record:
        raise HTTPException(status_code=404, detail="UserGameStat not found")

    if update_data.high_score is not None:
        record.high_score = update_data.high_score
    if update_data.games_played is not None:
        record.games_played = update_data.games_played

    await session.commit()
    await session.refresh(record)
    return record


@router.delete("/{user_id}/stats/{game_id}")
async def delete_user_stat(
        user_id: UUID,
        game_id: int,
        session: AsyncSession = Depends(get_session),
        current_user: User = Depends(get_current_user)
) -> dict:
    """
    Удаляет запись user_game_stats.
    """
    stmt = select(UserGameStat).where(
        UserGameStat.user_id == user_id,
        UserGameStat.game_id == game_id
    )
    record = (await session.scalars(stmt)).first()
    if not record:
        raise HTTPException(status_code=404, detail="UserGameStat not found")

    await session.delete(record)
    await session.commit()
    return {"detail": "UserGameStat deleted"}
