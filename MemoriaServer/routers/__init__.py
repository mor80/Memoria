from fastapi import APIRouter

from . import user, achievements, game_stats

all_routers = APIRouter(prefix="/api")

all_routers.include_router(user.router)
all_routers.include_router(achievements.router)
all_routers.include_router(game_stats.router)
