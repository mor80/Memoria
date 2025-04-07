from typing import Optional
from uuid import UUID

from pydantic import BaseModel


class AddGameDTO(BaseModel):
    """
    DTO для создания игры.
    """
    code: str
    name: str


class GameDTO(AddGameDTO):
    """
    DTO для ответа, содержит id.
    """
    id: int

    class Config:
        from_attributes = True


class UpdateGameDTO(BaseModel):
    """
    DTO для частичного обновления игры.
    """
    code: Optional[str] = None
    name: Optional[str] = None


class AddUserGameStatDTO(BaseModel):
    """
    Создание записи о статистике пользователя по игре.
    """
    game_id: int
    high_score: int = 0
    games_played: int = 0


class UserGameStatDTO(BaseModel):
    """
    Ответ (read-only).
    """
    user_id: UUID
    game_id: int
    high_score: int
    games_played: int

    class Config:
        from_attributes = True


class UpdateUserGameStatDTO(BaseModel):
    """
    Частичное обновление (high_score, games_played).
    """
    high_score: Optional[int] = None
    games_played: Optional[int] = None
