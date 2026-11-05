import sqlalchemy as sa
from sqlalchemy import String, Text, ForeignKey, Index
from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy.sql import func

from app.core.database import Base


class Entry(Base):
    __tablename__ = "entries"

    id: Mapped[str] = mapped_column(
        sa.UUID(as_uuid=False), primary_key=True, default=sa.text("gen_random_uuid()")
    )
    user_id: Mapped[str] = mapped_column(sa.UUID(as_uuid=False), index=True, nullable=False)
    title: Mapped[str | None] = mapped_column(String(200), nullable=True)
    body: Mapped[str] = mapped_column(Text, nullable=False)
    mood: Mapped[str | None] = mapped_column(String(50), nullable=True)
    parent_entry_id: Mapped[str | None] = mapped_column(
        sa.UUID(as_uuid=False), ForeignKey("entries.id"), nullable=True
    )
    created_at: Mapped[str] = mapped_column(
        sa.DateTime(timezone=True), server_default=func.now(), nullable=False
    )
    updated_at: Mapped[str] = mapped_column(
        sa.DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )

    parent = relationship("Entry", remote_side=[id], backref="children")

    __table_args__ = (
        Index("ix_entries_user_id_created_at", "user_id", sa.text("created_at DESC")),
    )
