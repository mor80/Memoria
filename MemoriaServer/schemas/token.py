# schemas/token.py
from pydantic import BaseModel

from schemas.user_schemas import UserDTO  # если нужно


class Token(BaseModel):
    access_token: str
    token_type: str
    user: UserDTO
