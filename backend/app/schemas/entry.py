from pydantic import BaseModel
from uuid import UUID
from datetime import datetime
from typing import Optional


class EntryBase(BaseModel):
    title: Optional[str] = None
    body: str
    mood: Optional[str] = None
    parent_entry_id: Optional[UUID] = None


class EntryCreate(EntryBase):
    pass


class EntryUpdate(BaseModel):
    title: Optional[str] = None
    body: Optional[str] = None
    mood: Optional[str] = None
    parent_entry_id: Optional[UUID] = None


class EntryResponse(EntryBase):
    id: UUID
    user_id: UUID
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}
