# AGENTS.md

Guidance for coding agents working in this repository. Prefer executable/config sources over README prose when they differ.

## Repo shape (monorepo)
- `backend/` — FastAPI service (Python, SQLAlchemy 2.x async, Alembic, PostgreSQL/Supabase).
- `frontend/` — Flutter app (Dart, Riverpod, Dio, go_router, Supabase Auth). Package name in `pubspec.yaml` is `journal_app`.
- Root `package.json` / `node_modules` are not part of the main app build; focus on `backend/` and `frontend/`.

## Backend (run from `backend/`)
- Setup: `python -m venv .venv` then activate `.venv`; `pip install -r requirements.txt` (pinned deps; no `pyproject.toml`/test deps in requirements).
- Dev server: `uvicorn app.main:app --reload` (add `--host 0.0.0.0` when testing from a physical device). Health: `GET /health`; API base: `/api/v1` (see `app/main.py`, `app/api/v1/router.py`).
- Migrations: `alembic upgrade head`. Run migrations from `backend/` (alembic `prepend_sys_path = .`).
  - `alembic/env.py` loads `app.core.config.settings` and converts `DATABASE_URL` from `+asyncpg` to `+psycopg2` for sync migrations; keep both `asyncpg` and `psycopg2-binary` available.
  - Autogenerate only sees models imported in `backend/alembic/env.py` (currently `app.models.entry`). Import new models there when adding tables.
- Config (`app/core/config.py`, pydantic-settings, reads `backend/.env`): `DATABASE_URL` (use `postgresql+asyncpg://...`), `SUPABASE_URL`, optional `SUPABASE_JWT_SECRET`. Copy shape from `backend/.env.example` only as a hint; verify required keys against `config.py`.
- Auth: JWT verified in `app/core/security.py` (JWKS ES256/RS256 by default; HS256 if legacy `SUPABASE_JWT_SECRET` set). Current user id = JWT `sub` (`app/api/deps.py`). All protected routes depend on `get_current_user_id`/bearer auth.

## Backend architecture & invariants
- Layering per feature (follow existing pattern): endpoint/HTTP in `app/api/v1/endpoints/` → service/business rules in `app/services/` → repository/DB in `app/repositories/`; SQLAlchemy models in `app/models/`, Pydantic schemas in `app/schemas/`. Wire routers in `app/api/v1/router.py`.
- **Security invariant:** every repository query must scope by authenticated `user_id`. The DB connection bypasses Supabase RLS, so app-layer ownership checks are the real protection. Do not weaken them; access to another user's resource should behave like not found (404), consistent with the API design.
- IDs in the current `Entry` model are UUIDs stored as strings (`sa.UUID(as_uuid=False)`); check existing model/schema types before changing ID handling.

## Backend testing (verify before assuming)
- `README.md` describes `pytest` in `backend/tests/` with ownership tests, but **no `backend/tests/` directory is committed** and `backend/.gitignore` ignores local `test_auth.py`/`test_entries.py`. There is no `pytest.ini`/committed test config and no CI workflow in the repo.
- If you add or run tests, confirm the runner, fixtures, and whether they hit a real DB/Supabase vs. mocks. Do not claim tests passed unless you ran them in this environment.

## Frontend (run from `frontend/`)
- Setup: `flutter pub get` (SDK constraint `^3.13.7` in `pubspec.yaml`).
- Run: `flutter run --dart-define-from-file=env.json`. `frontend/env.json` is git-ignored; required keys read in `lib/core/env.dart`: `API_BASE_URL`, `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`. Use only the Supabase publishable/anon key in the app.
- Emulator/device: Android emulator reaches host as `10.0.2.2`; physical devices need the host LAN IP and backend started with `--host 0.0.0.0`.
- Lint/analyze: uses `package:flutter_lints/flutter.yaml` via `frontend/analysis_options.yaml`; run `flutter analyze` from `frontend/` when making Dart changes.
- Structure: feature folders under `lib/features/<feature>/` (e.g. `auth`, `entries`, `onboarding`, `profile`) with simple MVVM — Screen/View → ViewModel (Riverpod) → Repository → model/API. Shared core in `lib/core/` (env, api_client, router, theme, widgets/validators).
- `frontend/lib/main.dart` is currently empty/WIP — inspect the real entrypoint/bootstrap (`app.dart`, router, Supabase init) before assuming app startup wiring.

## Cross-cutting
- Secrets: `backend/.env`, `frontend/env.json` are git-ignored; never commit DB passwords or Supabase secret/service-role keys.
- No `.github/workflows`, `opencode.json`, `CLAUDE.md`, or `.cursorrules` found. `README.md` is the main product/architecture reference; treat code/config as authoritative for commands and behavior.