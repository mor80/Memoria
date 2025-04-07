import os
from dataclasses import dataclass
from os import getenv

from dotenv import load_dotenv

load_dotenv()


@dataclass
class DatabaseConfig:
    """Database connection variables"""

    name: str = getenv("POSTGRES_DATABASE")
    user: str = getenv("POSTGRES_USER", "docker")
    passwd: str = getenv("POSTGRES_PASSWORD", None)
    port: int = int(getenv("POSTGRES_PORT", 5432))
    host: str = getenv("POSTGRES_HOST", "database")
    PG_URI: str = f"postgresql+asyncpg://{user}:{passwd}@{host}/{name}"


class Configuration:
    """All in one configuration's class"""
    SECRET_KEY = os.getenv("SECRET_KEY", "your-secret-key")
    db = DatabaseConfig()


config = Configuration()
