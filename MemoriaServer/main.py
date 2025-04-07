from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

# Импортируем модель User
# Функция для получения сессии (зависимость)
from routers import all_routers

# Импорт функций для хеширования пароля

app = FastAPI()

app.include_router(all_routers)
app.mount("/media", StaticFiles(directory="media"), name="media")

