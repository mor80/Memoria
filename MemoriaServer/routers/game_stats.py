from typing import List

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from database.models import Game, User
from database.session_maker import get_session
from schemas.game_schemas import GameDTO, AddGameDTO, UpdateGameDTO
from utils.auth import get_current_user

router = APIRouter(prefix="/game", tags=["Games"])


@router.post("/add", response_model=GameDTO, status_code=status.HTTP_201_CREATED)
async def create_game(
    data: AddGameDTO,
    session: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user)  # защита токеном
) -> GameDTO:
    """
    Создаёт новую игру. Проверяем уникальность поля 'code'.
    """
    stmt_check = select(Game).where(Game.code == data.code)
    existing = (await session.scalars(stmt_check)).first()
    if existing:
        raise HTTPException(
            status_code=400,
            detail="Game with this code already exists"
        )

    new_game = Game(code=data.code, name=data.name)
    session.add(new_game)
    await session.commit()
    await session.refresh(new_game)
    return new_game


@router.get("", response_model=List[GameDTO])
async def list_games(
    session: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user)  # защита токеном
) -> List[GameDTO]:
    """
    Возвращает список всех игр.
    """
    stmt = select(Game)
    results = (await session.scalars(stmt)).all()
    return results


@router.get("/{game_id}", response_model=GameDTO)
async def get_game(
    game_id: int,
    session: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user)  # защита токеном
) -> GameDTO:
    """
    Возвращает игру по ID или 404, если не найдена.
    """
    stmt = select(Game).where(Game.id == game_id)
    game = (await session.scalars(stmt)).first()
    if not game:
        raise HTTPException(status_code=404, detail="Game not found")
    return game


@router.patch("/{game_id}", response_model=GameDTO)
async def update_game(
    game_id: int,
    update_data: UpdateGameDTO,
    session: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user)  # защита токеном
) -> GameDTO:
    """
    Частичное обновление игры (code, name).
    Проверка на уникальный code, если меняем.
    """
    stmt = select(Game).where(Game.id == game_id)
    game = (await session.scalars(stmt)).first()
    if not game:
        raise HTTPException(status_code=404, detail="Game not found")

    if update_data.code is not None:
        stmt_check = select(Game).where(Game.code == update_data.code, Game.id != game_id)
        existing = (await session.scalars(stmt_check)).first()
        if existing:
            raise HTTPException(status_code=400, detail="Another game with this code already exists")
        game.code = update_data.code

    if update_data.name is not None:
        game.name = update_data.name

    await session.commit()
    await session.refresh(game)
    return game


@router.delete("/{game_id}")
async def delete_game(
    game_id: int,
    session: AsyncSession = Depends(get_session),
    current_user: User = Depends(get_current_user)  # защита токеном
) -> dict:
    """
    Удаляет игру по ID.
    """
    stmt = select(Game).where(Game.id == game_id)
    game = (await session.scalars(stmt)).first()
    if not game:
        raise HTTPException(status_code=404, detail="Game not found")

    await session.delete(game)
    await session.commit()
    return {"detail": "Game deleted"}
