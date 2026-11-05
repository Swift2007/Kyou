from typing import Annotated
from uuid import UUID
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.deps import get_db, get_current_user_id
from app.repositories.entry import EntryRepository
from app.services.entry import EntryService
from app.schemas.entry import EntryCreate, EntryUpdate, EntryResponse

router = APIRouter()


def get_entry_service(session: AsyncSession = Depends(get_db)) -> EntryService:
    repository = EntryRepository(session)
    return EntryService(repository)


EntryServiceDep = Annotated[EntryService, Depends(get_entry_service)]
UserIdDep = Annotated[UUID, Depends(get_current_user_id)]


@router.post("/", response_model=EntryResponse, status_code=status.HTTP_201_CREATED)
async def create_entry(
    entry_in: EntryCreate,
    service: EntryServiceDep,
    user_id: UserIdDep,
):
    return await service.create_entry(
        user_id=user_id,
        title=entry_in.title,
        body=entry_in.body,
        mood=entry_in.mood,
        parent_entry_id=entry_in.parent_entry_id,
    )


@router.get("/", response_model=list[EntryResponse])
async def list_entries(
    service: EntryServiceDep,
    user_id: UserIdDep,
    offset: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
):
    return await service.list_entries(user_id=user_id, offset=offset, limit=limit)


@router.get("/{entry_id}", response_model=EntryResponse)
async def get_entry(
    entry_id: UUID,
    service: EntryServiceDep,
    user_id: UserIdDep,
):
    entry = await service.get_entry(entry_id, user_id)
    if entry is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Entry not found")
    return entry


@router.put("/{entry_id}", response_model=EntryResponse)
async def update_entry(
    entry_id: UUID,
    entry_in: EntryUpdate,
    service: EntryServiceDep,
    user_id: UserIdDep,
):
    entry = await service.update_entry(
        entry_id=entry_id,
        user_id=user_id,
        title=entry_in.title,
        body=entry_in.body,
        mood=entry_in.mood,
        parent_entry_id=entry_in.parent_entry_id,
    )
    if entry is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Entry not found")
    return entry


@router.delete("/{entry_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_entry(
    entry_id: UUID,
    service: EntryServiceDep,
    user_id: UserIdDep,
):
    deleted = await service.delete_entry(entry_id, user_id)
    if not deleted:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Entry not found")
    return None
