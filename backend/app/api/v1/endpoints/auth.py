from datetime import datetime, timedelta, timezone
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import get_db, get_current_user
from app.repositories.user import UserRepository
from app.services.user import UserService
from app.schemas.user import UserResponse


router = APIRouter()

# Users created within this window are treated as "new" for onboarding routing.
# This is a pragmatic heuristic until an explicit onboarding_completed flag exists.
NEW_USER_WINDOW = timedelta(minutes=10)


def get_user_service(session: AsyncSession = Depends(get_db)) -> UserService:
    repository = UserRepository(session)
    return UserService(repository)


UserServiceDep = Depends(get_user_service)


def _is_recently_created(created_at) -> bool:
    if created_at is None:
        return False
    now = datetime.now(timezone.utc)
    # created_at may be naive depending on driver; normalize for comparison.
    if created_at.tzinfo is None:
        created_at = created_at.replace(tzinfo=timezone.utc)
    return (now - created_at) <= NEW_USER_WINDOW


@router.get("/me", response_model=UserResponse)
async def get_current_user_profile(
    user: dict = Depends(get_current_user),
    service: UserService = UserServiceDep,
):
    """Return the authenticated user's profile, creating it on first access."""
    email = user.get("email") or ""
    user_obj, is_new = await service.get_or_create(
        user_id=user["user_id"], email=email
    )
    return {
        "id": user_obj.id,
        "email": user_obj.email,
        "created_at": user_obj.created_at,
        "is_new_user": is_new or _is_recently_created(user_obj.created_at),
    }

