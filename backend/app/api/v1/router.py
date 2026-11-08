from uuid import UUID

from fastapi import APIRouter, Depends

from app.api.deps import get_current_user_id
from app.api.v1.endpoints.entry import router as entries_router
from app.api.v1.endpoints.auth import router as auth_router

api_router = APIRouter()


api_router.include_router(auth_router, prefix="/auth")
api_router.include_router(entries_router, prefix="/entries")