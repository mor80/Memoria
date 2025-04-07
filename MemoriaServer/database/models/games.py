from typing import TYPE_CHECKING

from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from database.models.base import Base
from database.models.user_game_stats import UserGameStat

if TYPE_CHECKING:
    from .user_game_stats import UserGameStat


class Game(Base):
    __tablename__ = "games"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    code: Mapped[str] = mapped_column(String(50), unique=True, nullable=False)  # machine key e.g. "memory_match"
    name: Mapped[str] = mapped_column(String(100), nullable=False)

    stats: Mapped[list["UserGameStat"]] = relationship(back_populates="game", cascade="all, delete-orphan")
