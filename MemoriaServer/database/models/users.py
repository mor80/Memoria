from typing import TYPE_CHECKING
from uuid import UUID

from sqlalchemy import UUID as PG_UUID, text, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from database.models.base import Base
from .user_game_stats import UserGameStat

if TYPE_CHECKING:
    from .user_achievement import UserAchievement
    from .user_game_stats import UserGameStat


class User(Base):
    __tablename__ = "users"

    id: Mapped[UUID] = mapped_column(PG_UUID(as_uuid=True), primary_key=True, server_default=text("uuid_generate_v4()"))
    name: Mapped[str] = mapped_column(String(100))
    experience: Mapped[int] = mapped_column(server_default='1000')

    email: Mapped[str] = mapped_column(String(120), unique=True)
    password: Mapped[str] = mapped_column(String(255), nullable=False)

    avatar_url: Mapped[str | None] = mapped_column(String, nullable=True)

    achievements: Mapped[list["UserAchievement"]] = relationship(back_populates="user")
    game_stats: Mapped[list["UserGameStat"]] = relationship(back_populates="user", cascade="all, delete-orphan")