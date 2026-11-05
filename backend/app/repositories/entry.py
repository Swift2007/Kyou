from uuid import UUID
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select, delete, func
from sqlalchemy.orm import selectinload

from app.models.entry import Entry


class EntryRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def create(self, user_id: UUID, title: str | None, body: str, mood: str | None, parent_entry_id: UUID | None) -> Entry:
        entry = Entry(
            user_id=user_id,
            title=title,
            body=body,
            mood=mood,
            parent_entry_id=parent_entry_id,
        )
        self.session.add(entry)
        await self.session.commit()
        await self.session.refresh(entry)
        return entry

    async def get_by_id(self, entry_id: UUID, user_id: UUID) -> Entry | None:
        result = await self.session.execute(
            select(Entry).where(Entry.id == entry_id, Entry.user_id == user_id)
        )
        return result.scalar_one_or_none()

    async def list_by_user(
        self, user_id: UUID, offset: int = 0, limit: int = 50
    ) -> list[Entry]:
        result = await self.session.execute(
            select(Entry)
            .where(Entry.user_id == user_id)
            .order_by(Entry.created_at.desc())
            .offset(offset)
            .limit(limit)
        )
        return list(result.scalars().all())

    async def update(self, entry: Entry, title: str | None, body: str | None, mood: str | None, parent_entry_id: UUID | None) -> Entry:
        if title is not None:
            entry.title = title
        if body is not None:
            entry.body = body
        if mood is not None:
            entry.mood = mood
        if parent_entry_id is not None:
            entry.parent_entry_id = parent_entry_id
        await self.session.commit()
        await self.session.refresh(entry)
        return entry

    async def delete(self, entry: Entry) -> None:
        await self.session.delete(entry)
        await self.session.commit()

    async def count_by_user(self, user_id: UUID) -> int:
        result = await self.session.execute(
            select(func.count()).select_from(Entry).where(Entry.user_id == user_id)
        )
        return result.scalar_one()
