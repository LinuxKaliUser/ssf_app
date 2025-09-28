# Spring Boot Backend

This backend provides REST APIs for user account management and is configured for PostgreSQL 14.

## Features
- User registration and login (with email, username, password)
- CRUD operations for accounts
- PostgreSQL 14 integration (via Docker Compose)
- JPA/Hibernate for persistence

## Development
- Java 17+
- Spring Boot 3.x
- PostgreSQL 14 (via Docker or local)

## Quickstart
1. Copy `.env.example` to `.env` and adjust DB credentials if needed.
2. Run `docker-compose up` to start PostgreSQL.
3. Build and run the Spring Boot app (see below).

## Endpoints
- `POST /api/accounts/register` — Register new user
- `POST /api/accounts/login` — Login
- `GET /api/accounts/me` — Get current user
- `GET /api/accounts` — List all users (admin only)

## Docker Compose
A `docker-compose.yml` is provided for local PostgreSQL 14.

---
