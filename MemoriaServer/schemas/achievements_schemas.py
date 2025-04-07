from typing import Optional
from uuid import UUID

from pydantic import BaseModel


class AddAchievementDTO(BaseModel):
    """
    DTO для создания нового достижения.
    """
    name: str
    description: str
    max_progress: int


class AchievementDTO(AddAchievementDTO):
    """
    DTO для ответа, содержит id.
    """
    id: int

    class Config:
        # Актуально для Pydantic v2 (заменяет orm_mode=True из v1)
        from_attributes = True


class UpdateAchievementDTO(BaseModel):
    """
    DTO для частичного обновления достижения.
    """
    name: Optional[str] = None
    description: Optional[str] = None
    max_progress: Optional[int] = None


class AddUserAchievementDTO(BaseModel):
    """
    Создание записи о достижении пользователя.
    Поле user_id обычно приходит в path, а здесь указываем achievement_id и т. д.
    """
    achievement_id: int
    achieved: bool = False
    progress: int = 0


class UserAchievementDTO(BaseModel):
    """
    Ответ (read-only) при получении/обновлении.
    """
    user_id: UUID
    achievement_id: int
    achieved: bool
    progress: int

    class Config:
        from_attributes = True


class UpdateUserAchievementDTO(BaseModel):
    """
    Частичное обновление (achieved, progress).
    """
    achieved: Optional[bool] = None
    progress: Optional[int] = None
