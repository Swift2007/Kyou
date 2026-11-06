# Kyou

A journaling app that gets more valuable the longer you use it.

Most journals are a place to write things down and never look at again. Kyou treats your journal as a conversation with yourself over time: you can reply to what you wrote months ago, make predictions and find out how well you read your own life, and have old entries resurface when they are relevant to what you are going through now.

---

## Table of contents

- [What makes it different](#what-makes-it-different)
- [Features](#features)
- [How it works](#how-it-works)
- [Tech stack](#tech-stack)
- [Project structure](#project-structure)
- [Data model](#data-model)
- [API overview](#api-overview)
- [Getting started](#getting-started)
- [Testing](#testing)
- [Security and privacy](#security-and-privacy)
- [Roadmap](#roadmap)

---

## What makes it different

1. **Conversations with your past self.** Reply to any old entry. Replies thread back through time, so a journal becomes a dialogue instead of an archive.
2. **Prediction journaling.** Write down what you expect to happen ("I'll get the internship", "this will blow over"). The app brings the prediction back when it is due so you can mark it right or wrong. Over time you see how well your gut is calibrated.
3. **Resurfacing by relevance, not date.** "On this day" is common. Kyou surfaces an old entry because it is similar to what you are writing about now, for example the time you got through a similar situation.
4. **Shared journals with simultaneous reveal.** You and a partner, friend or mentor answer the same prompt privately. Both entries unlock only once both of you have written.

---

## Features

### Writing

| Feature | Description | Status |
|---|---|---|
| Entries | Create, edit, delete and browse journal entries with an optional title | In progress |
| Mood | Pick a mood for each entry (great, good, okay, low, rough), with intensity and custom moods planned | In progress |
| Tags | Organise entries with tags such as #work or #family | Planned |
| Formatting | Bold, italic, headings, bullet lists and checklists | Planned |
| Photos | Attach photos or take one in the app | Planned |
| Voice notes | Record a short voice note, transcribed and attached to the entry | Planned |
| Offline drafts | Keep writing without a connection and sync later | Planned |
| Search | Full-text search across all entries | Planned |

### Reflection

| Feature | Description | Status |
|---|---|---|
| Replies to past self | Respond to an old entry; replies are linked as a thread | Planned |
| Predictions | Record a prediction with a due date and confidence, resolve it later | Planned |
| Calibration stats | See how often your predictions turned out right | Planned |
| Smart resurfacing | Related past entries appear while you write, based on meaning (vector similarity) | Planned |
| Insights | Patterns across people, places and moods; automatic "life chapters" | Planned |

### Sharing

| Feature | Description | Status |
|---|---|---|
| Shared journals | Answer a shared prompt privately; entries reveal only when everyone has written | Planned |

### Privacy and control

| Feature | Description | Status |
|---|---|---|
| Accounts | Email and password sign-up and login through Supabase Auth | Backend verified |
| Onboarding flow | Multi-step onboarding for new accounts (welcome, profile, goals, rhythm, topics) | In progress |
| Home dashboard | Neubrutalist dashboard with calendar, recent entries, and quick actions | In progress |
| Welcome & Auth UI | Journal welcome screen, sign in/sign up screens with Google auth UI | In progress |
| App lock | Biometric or PIN lock, plus an optional decoy PIN that opens a harmless fake journal | Planned |
| Legacy switch | Choose which entries are passed to a trusted person if you are inactive for a long time | Planned |
| Fading entries | Entries that delete themselves after a chosen time | Planned |
| Export and delete | Download your data or delete your account | Planned |

---

## How it works

```
┌────────────────┐   sign in    ┌────────────────┐
│  Flutter app   │ ───────────► │ Supabase Auth  │
│  (frontend)    │ ◄─────────── │                │
└───────┬────────┘   JWT token  └────────────────┘
        │
        │ HTTPS + "Authorization: Bearer <JWT>"
        ▼
┌────────────────┐   verifies   ┌────────────────┐
│   FastAPI      │ ───────────► │ Supabase public│
│   (backend)    │   signature  │ signing keys   │
└───────┬────────┘              └────────────────┘
        │ SQL (async)
        ▼
┌────────────────┐
│  PostgreSQL    │
│  (Supabase)    │
└────────────────┘
```

1. The user signs up or logs in from the Flutter app. The app talks to **Supabase Auth** directly and receives a signed JWT.
2. For every request, the app sends that token to the **FastAPI** backend.
3. The backend verifies the token's signature, expiry and audience, and reads the user's ID from it. It never sees or stores passwords.
4. Every database query is filtered by that user ID, so a user can only ever read or change their own data.
5. Data is stored in **PostgreSQL** (hosted by Supabase). Similarity search for resurfacing will use the `pgvector` extension.

### Frontend: simple MVVM

The app uses a small, flat version of MVVM, organised by feature:

- **Screen (View)** shows state and calls ViewModel methods. It never talks to the API.
- **ViewModel** holds state and logic, calls the repository, and never imports widgets. Built with Riverpod.
- **Repository** talks to the API or Supabase and returns typed models.
- **Model** is a plain Dart class with `fromJson` and `toJson`.

Example flow when the user taps Save: `EntryEditorScreen` → `EntriesViewModel.create()` → `EntriesRepository.create()` → `POST /entries` → database, then the state flows back up and the list refreshes.

### Backend: layered

Requests flow through four layers, each with one job:

- **Endpoint** handles HTTP only (parse the request, return the response, map errors to status codes)
- **Service** holds business rules (for example, a reply can only point at the user's own entry)
- **Repository** holds database queries and always filters by `user_id`
- **Model / Schema** define tables (SQLAlchemy) and request/response shapes (Pydantic)

---

## Tech stack

| Part | Technology |
|---|---|
| Mobile app | Flutter (Android and iOS) |
| State management | Riverpod |
| HTTP and routing | Dio, go_router |
| Backend | FastAPI (Python), SQLAlchemy 2.x async, Alembic migrations |
| Database | PostgreSQL on Supabase |
| Authentication | Supabase Auth (JWT) |
| Similarity search (planned) | pgvector |
| Background jobs (planned) | APScheduler |

---

## Project structure

```
Kyou/
├── frontend/                  # Flutter app
│   └── lib/
│       ├── main.dart
│       ├── app.dart
│       ├── core/              # env, api client, router, theme
│       └── features/
│           ├── auth/          # repository, viewmodel, login and signup screens
│           └── entries/       # model, repository, viewmodel, list and editor screens
│
├── backend/                   # FastAPI service
│   ├── alembic/               # database migrations
│   ├── app/
│   │   ├── main.py
│   │   ├── core/              # config, database, security (JWT verification)
│   │   ├── api/               # dependencies and versioned routers
│   │   ├── models/            # SQLAlchemy tables
│   │   ├── schemas/           # Pydantic schemas
│   │   ├── repositories/      # database queries
│   │   ├── services/          # business rules
│   │   └── jobs/              # scheduled tasks (planned)
│   └── tests/
│
└── README.md
```

New features get their own folder in `features/` (frontend) and their own endpoint, service and repository files (backend) when they are built.

---

## Data model

Current and planned tables:

| Table | Purpose |
|---|---|
| `entries` | id, user_id, title, body, mood, parent_entry_id (for replies), created_at, updated_at |
| `predictions` | entry link, statement, due date, confidence, outcome, resolved date |
| `tags`, `entry_tags` | tags and the many-to-many link to entries |
| `shared_journals`, `shared_members`, `shared_responses` | shared prompts and the reveal rule |
| `attachments` | photos and voice notes linked to entries |

`entries.parent_entry_id` is a self-reference. That single column is what turns a list of entries into a thread of replies through time.

---

## API overview

Base path: `/api/v1`. Every route except `/health` requires `Authorization: Bearer <access token>`.

| Method | Path | Description |
|---|---|---|
| GET | `/health` | Service status (no auth) |
| GET | `/me` | Returns the authenticated user's ID |
| POST | `/entries` | Create an entry |
| GET | `/entries?limit=20&offset=0` | List your entries, newest first (paginated) |
| GET | `/entries/{id}` | Get one entry |
| PATCH | `/entries/{id}` | Update an entry |
| DELETE | `/entries/{id}` | Delete an entry |

Predictions, replies, resurfacing and shared journals will be added under the same prefix.

---

## Getting started

### Prerequisites

- Python 3.11 or newer
- Flutter SDK (stable channel) and an Android emulator or a device
- A Supabase project (free tier is enough)

### 1. Supabase

1. Create a project at supabase.com.
2. Note your **Project URL** and **publishable (anon) key** under Project Settings → API Keys.
3. Get the **session pooler** connection string under Connect. Use the session pooler rather than the direct connection, because the direct host is IPv6-only on the free plan and many networks do not support it.
4. Create a test user under Authentication → Users.

### 2. Backend

```bash
cd backend
python -m venv .venv

# Windows (PowerShell)
.venv\Scripts\Activate.ps1
# macOS / Linux
source .venv/bin/activate

pip install -r requirements.txt
```

Create `backend/.env`:

```
DATABASE_URL=postgresql+asyncpg://postgres.PROJECTREF:PASSWORD@HOST.pooler.supabase.com:5432/postgres
SUPABASE_URL=https://PROJECTREF.supabase.co
SUPABASE_JWT_SECRET=
```

- Use `postgresql+asyncpg://` at the start of `DATABASE_URL`.
- Remove any square brackets from the Supabase template. Use a password with letters and numbers only, or URL-encode special characters.
- Leave `SUPABASE_JWT_SECRET` empty unless your project still uses the legacy HS256 secret.
- `SUPABASE_URL` is only the project address, with no path after `.supabase.co`.

Apply the migrations and start the server:

```bash
alembic upgrade head
uvicorn app.main:app --reload
```

Check `http://localhost:8000/health`. The interactive docs are at `http://localhost:8000/docs`.

### 3. Frontend

```bash
cd frontend
flutter pub get
```

Create `frontend/env.json` (this file is git-ignored):

```json
{
  "API_BASE_URL": "http://10.0.2.2:8000/api/v1",
  "SUPABASE_URL": "https://PROJECTREF.supabase.co",
  "SUPABASE_PUBLISHABLE_KEY": "your-publishable-key"
}
```

Run the app:

```bash
flutter run --dart-define-from-file=env.json
```

Notes:

- `10.0.2.2` is how the Android emulator reaches your computer's localhost.
- On a physical phone, use your computer's local network IP, and start the backend with `uvicorn app.main:app --reload --host 0.0.0.0`.
- Use only the publishable key in the app. Never put the service role or secret key in the frontend.

---

## Testing

Backend tests use pytest with two simulated users, so they do not call Supabase:

```bash
cd backend
pytest
```

The most important test checks that **user B cannot read, update or delete user A's entries**. Authentication can also be verified by logging in with a test user, calling `GET /api/v1/me` with the token, and confirming that a missing or fake token is rejected.

---

## Security and privacy

- **Token verification:** the backend checks every JWT's signature, expiry and audience.
- **Ownership checks:** every repository query filters by the authenticated `user_id`. The backend connects to the database with a role that bypasses Row Level Security, so these filters are the real protection and are covered by tests.
- **No information leaks:** requesting another user's entry returns "not found", the same as a missing entry.
- **Row Level Security enabled with no policies** on application tables, so the public Supabase Data API cannot expose them.
- **Secrets:** `.env` and `env.json` are git-ignored. Never commit database passwords or secret keys.
- **Planned:** app lock, decoy PIN, fading entries, the legacy switch, and data export and deletion. The data model is kept ready for optional client-side encryption, which would trade server-side search and AI features for stronger privacy.

---

## Roadmap

1. **Foundation** (done): FastAPI, Supabase database connection, JWT verification
2. **Entries** (in progress): backend API, then Flutter list and editor, with sign-up and login
3. **Writing tools:** tags, formatting, photos, voice notes, offline drafts, search
4. **Signature features:** replies to past self, predictions and calibration, smart resurfacing
5. **Sharing:** shared journals with simultaneous reveal
6. **Privacy and polish:** app lock, decoy PIN, export, account deletion, legacy switch
7. **Launch:** deployment, CI/CD, beta testing

---

## License

To be decided.
