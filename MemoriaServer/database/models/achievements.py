from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column

from database.models import Base


class Achievement(Base):
    __tablename__ = "achievements"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(100))
    description: Mapped[str] = mapped_column(String(255))
    max_progress: Mapped[int]