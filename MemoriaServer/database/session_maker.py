from sqlalchemy.ext.asyncio import async_sessionmaker, create_async_engine, AsyncSession, AsyncConnection

from config import config
from database.models.base import Base

engine = create_async_engine(url=config.db.PG_URI, echo=True)
sessionmaker = async_sessionmaker(engine, expire_on_commit=False)


async def get_session() -> AsyncSession:
    async with sessionmaker() as session:
        yield session


async def init_models() -> None:
    async with engine.begin() as conn:
        conn: AsyncConnection
        await conn.run_sync(Base.metadata.drop_all)
        await conn.run_sync(Base.metadata.create_all)
