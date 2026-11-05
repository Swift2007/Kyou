import asyncio
from sqlalchemy import text
from app.core.database import engine

async def main():
    async with engine.connect() as conn:
        result = await conn.execute(text("select 1"))
        print("Connected:", result.scalar())

asyncio.run(main())