from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import get_db, get_current_user_id
from app.repositories.user import UserRepository
from app.services.user import UserService
from app.schemas.user import UserResponse


router = APIRouter()


def get_user_service(session: AsyncSession = Depends(get_db)) -> UserService:
    repository = UserRepository(session)
    return UserService(repository)


UserServiceDep = Depends(get_user_service)
UserIdDep = Depends(get_current_user_id)


@router.get("/me", response_model=UserResponse)
async def get_current_user(
    user_id: UUID = UserIdDep,
    service: UserService = UserServiceDep,
):
    """Return the authenticated user's profile, creating it on first access."""
    return await service.get_or_create(user_id=user_id, email="")

