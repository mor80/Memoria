from typing import TYPE_CHECKING
from uuid import UUID

from sqlalchemy import UUID as PG_UUID, ForeignKey
from sqlalchemy.orm import Mapped, relationship
from sqlalchemy.orm import mapped_column

from database.models import Base

if TYPE_CHECKING:
    from .users import User
    from .achievements import Achievement


class UserAchievement(Base):
    __tablename__ = "user_achievements"

    user_id: Mapped[UUID] = mapped_column(PG_UUID(as_uuid=True), ForeignKey("users.id"), primary_key=True)
    achievement_id: Mapped[int] = mapped_column(ForeignKey("achievements.id"), primary_key=True)
    achieved: Mapped[bool] = mapped_column(server_default="0")
    progress: Mapped[int] = mapped_column(server_default="0")

    user: Mapped["User"] = relationship(back_populates="achievements")
    achievement: Mapped["Achievement"] = relationship()
