from uuid import UUID

from app.repositories.user import UserRepository


class UserService:
    def __init__(self, repository: UserRepository):
        self.repository = repository

    async def get_by_id(self, user_id: UUID):
        return await self.repository.get_by_id(user_id)

    async def get_by_email(self, email: str):
        return await self.repository.get_by_email(email)

    async def get_or_create(self, user_id: UUID, email: str):
        user = await self.repository.get_by_id(user_id)
        if user is not None:
            return user
        return await self.repository.create(user_id=user_id, email=email)
