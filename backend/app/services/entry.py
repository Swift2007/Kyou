from uuid import UUID

from app.repositories.entry import EntryRepository


class EntryService:
    def __init__(self, repository: EntryRepository):
        self.repository = repository

    async def create_entry(
        self,
        user_id: UUID,
        title: str | None,
        body: str,
        mood: str | None,
        parent_entry_id: UUID | None,
    ):
        return await self.repository.create(
            user_id=user_id,
            title=title,
            body=body,
            mood=mood,
            parent_entry_id=parent_entry_id,
        )

    async def get_entry(self, entry_id: UUID, user_id: UUID):
        entry = await self.repository.get_by_id(entry_id, user_id)
        if entry is None:
            return None
        return entry

    async def list_entries(
        self, user_id: UUID, offset: int = 0, limit: int = 50
    ):
        return await self.repository.list_by_user(user_id, offset=offset, limit=limit)

    async def update_entry(
        self,
        entry_id: UUID,
        user_id: UUID,
        title: str | None,
        body: str | None,
        mood: str | None,
        parent_entry_id: UUID | None,
    ):
        entry = await self.repository.get_by_id(entry_id, user_id)
        if entry is None:
            return None
        return await self.repository.update(
            entry, title=title, body=body, mood=mood, parent_entry_id=parent_entry_id
        )

    async def delete_entry(self, entry_id: UUID, user_id: UUID) -> bool:
        entry = await self.repository.get_by_id(entry_id, user_id)
        if entry is None:
            return False
        await self.repository.delete(entry)
        return True
