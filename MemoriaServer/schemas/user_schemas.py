from typing import Optional
from uuid import UUID

from pydantic import BaseModel, EmailStr


class LoginDTO(BaseModel):
    email: EmailStr
    password: str


class AddUserDTO(BaseModel):
    """
    DTO для создания пользователя (без аватара).
    """
    name: str
    email: EmailStr
    password: str


class UserDTO(BaseModel):
    id: UUID
    name: str
    experience: int
    email: EmailStr
    avatar_url: Optional[str] = None  # путь к картинке (если есть)

    class Config:
        # Pydantic v2 вариант
        from_attributes = True


class UpdateUserDTO(BaseModel):
    """
    DTO для частичного обновления пользователя.
    """
    name: Optional[str] = None
    email: Optional[EmailStr] = None
    experience: Optional[int] = None
