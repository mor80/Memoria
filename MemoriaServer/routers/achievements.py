from typing import List

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from database.models import Achievement, User
from database.session_maker import get_session
from schemas.achievements_schemas import (
    AchievementDTO,
    AddAchievementDTO,
    UpdateAchievementDTO
)
from utils.auth import get_current_user

router = APIRouter(prefix="/achievement", tags=["Achievements"])


@router.post("", response_model=AchievementDTO, status_code=status.HTTP_201_CREATED)
async def create_achievement(
    data: AddAchievementDTO,
    session: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user)  # защита токеном
) -> AchievementDTO:
    """
    Создаёт новое достижение.
    """
    new_ach = Achievement(
        name=data.name,
        description=data.description,
        max_progress=data.max_progress
    )
    session.add(new_ach)
    await session.commit()
    await session.refresh(new_ach)
    return new_ach


@router.get("", response_model=List[AchievementDTO])
async def list_achievements(
    session: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user)  # защита токеном
) -> List[AchievementDTO]:
    """
    Возвращает список всех достижений.
    """
    stmt = select(Achievement)
    results = (await session.scalars(stmt)).all()
    return results


@router.get("/{achievement_id}", response_model=AchievementDTO)
async def get_achievement(
    achievement_id: int,
    session: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user)  # защита токеном
) -> AchievementDTO:
    """
    Возвращает достижение по ID или 404, если не найдено.
    """
    stmt = select(Achievement).where(Achievement.id == achievement_id)
    ach = (await session.scalars(stmt)).first()
    if not ach:
        raise HTTPException(status_code=404, detail="Achievement not found")
    return ach


@router.patch("/{achievement_id}", response_model=AchievementDTO)
async def update_achievement(
    achievement_id: int,
    update_data: UpdateAchievementDTO,
    session: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user)  # защита токеном
) -> AchievementDTO:
    """
    Частичное обновление данных достижения (name, description, max_progress).
    """
    stmt = select(Achievement).where(Achievement.id == achievement_id)
    ach = (await session.scalars(stmt)).first()
    if not ach:
        raise HTTPException(status_code=404, detail="Achievement not found")

    if update_data.name is not None:
        ach.name = update_data.name
    if update_data.description is not None:
        ach.description = update_data.description
    if update_data.max_progress is not None:
        ach.max_progress = update_data.max_progress

    await session.commit()
    await session.refresh(ach)
    return ach


@router.delete("/{achievement_id}")
async def delete_achievement(
    achievement_id: int,
    session: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user)  # защита токеном
) -> dict:
    """
    Удаляет достижение по ID.
    """
    stmt = select(Achievement).where(Achievement.id == achievement_id)
    ach = (await session.scalars(stmt)).first()
    if not ach:
        raise HTTPException(status_code=404, detail="Achievement not found")

    await session.delete(ach)
    await session.commit()
    return {"detail": "Achievement deleted"}
