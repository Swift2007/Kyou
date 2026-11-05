from uuid import UUID

from fastapi import APIRouter, Depends

from app.api.deps import get_current_user_id

api_router = APIRouter()


@api_router.get("/me")
async def me(user_id: UUID = Depends(get_current_user_id)):
    return {"user_id": user_id}