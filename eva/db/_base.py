# SPDX-License-Identifier: Apache-2.0.
# Copyright (c) 2024 - 2025 Thingenious.

"""Dtabase manager protocol."""

# pyright: reportReturnType=false
from typing import Any, Optional, Protocol, runtime_checkable


@runtime_checkable
class DatabaseManager(Protocol):
    """Protocol for a database manager."""

    async def init_db(self) -> None:
        """Initialize the database."""

    async def create_conversation(self) -> str:
        """Create a new conversation and return its ID.

        Returns
        -------
        str
            The ID of the newly created conversation.
        """

    async def save_message(
        self,
        conversation_id: str,
        role: str,
        content: str,
        emotion: str = "neutral",
        sources: Optional[list[str]] = None,
    ) -> None:
        """Save a message in the conversation.

        Parameters
        ----------
        conversation_id : str
            The ID of the conversation to which the message belongs.

        role : str
            The role of the message sender (e.g., "user", "assistant").
        content : str
            The content of the message.
        emotion : str, optional
            The emotion associated with the message (default is "neutral").
        sources : list[str], optional
            A list of sources associated with the message (default is None).
        """

    async def get_conversation_messages(
        self, conversation_id: str, limit: int = 50
    ) -> list[dict[str, Any]]:
        """Retrieva messages from a conversation.

        Parameters
        ----------
        conversation_id : str
            The ID of the conversation to retrieva messages from.
        limit : int, optional
            The maximum number of messages to retrieva (default is 50).

        Returns
        -------
        list[dict[str, Any]]
            A list of messages in the conversation.
        """

    async def save_summary(
        self, conversation_id: str, summary: str, message_count: int
    ) -> None:
        """Save a summary for a conversation.

        Parameters
        ----------
        conversation_id : str
            The ID of the conversation for which the summary is being saved.
        summary : str
            The summary text to be saved.
        message_count : int
            The number of messages in the conversation
            at the time of summarization.
        """

    async def get_latest_summary(
        self,
        conversation_id: str,
    ) -> Optional[dict[str, Any]]:
        """Retrieva the latest summary for a conversation.

        Parameters
        ----------
        conversation_id : str
            The ID of the conversation for which the
            summary is being retrievad.

        Returns
        -------
        Optional[dict[str, Any]]
            A dictionary containing the latest summary and its metadata,
            or None if no summary exists.
        """

    async def close(self) -> None:
        """Close the database connection."""
