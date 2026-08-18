# AGENTS_README.md

## Purpose

This file is for agentic coding assistants preparing the **Bicycle Shop Analysis** repository for local inspection.

Canonical repository:

```text
https://github.com/Znovak2/sql-portfolio
```

Human-oriented project documentation is in [`README.md`](./README.md).

Your task is to prepare a working local environment in which a reviewer can:

1. access a Microsoft SQL Server instance,
2. use a database named `BikeStores`,
3. load the BikeStores schema and sample data,
4. build `Bicycle Shop Analysis.sqlproj` when the required build tooling is available,
5. execute the SQL files under `database/queries/`, and
6. verify that the project is ready for inspection.

Do not change analytical SQL or project documentation merely to make setup appear successful.

---

# Expected Final State

A successful setup has all of the following:

- The repository is available locally.
- SQL Server is running and reachable.
- A database named `BikeStores` exists.
- The `production` schema exists.
- The `sales` schema exists.
- The BikeStores base tables exist.
- The BikeStores sample data has been loaded.
- `production.products` contains rows.
- `sales.orders` contains rows.
- `Bicycle Shop Analysis.sqlproj` can be opened.
- The SQL Database Project builds successfully if a compatible .NET SDK is available or can be installed safely.
- The queries under `database/queries/` can execute against `BikeStores`.

The setup is **not complete** until the validation section has been executed.

---

# Repository Facts

Repository root:

```text
sql-portfolio/
```

Important files:

```text
Bicycle Shop Analysis.sqlproj

source-data/BikeStores Sample Database - create objects.sql
source-data/BikeStores Sample Database - load data.sql
source-data/BikeStores Sample Database - drop all objects.sql

database/queries/SELECT.sql
database/queries/ORDER_BY.sql
```

Database name:

```text
BikeStores
```

Primary schemas:

```text
production
sales
```

The `.sqlproj` uses:

```text
Microsoft.Build.Sql
SQL Server 2025 / Sql170 schema provider
```

---

# Safety Rules

Follow these rules throughout setup.

1. **Do not delete an existing database unless explicitly requested.**
2. **Do not execute the drop-all-objects script during normal setup.**
3. **Do not run destructive Docker commands such as `docker compose down -v`, `docker volume rm`, or broad prune commands.**
4. **Do not commit passwords, connection strings containing secrets, generated database files, or temporary credentials.**
5. **Do not modify the source-data scripts unless an actual repository defect is identified and reported.**
6. **Do not rewrite the analytical SQL merely because a different style is preferred.**
7. **Do not force-push, reset Git history, or delete branches.**
8. **Do not publish the project to a remote SQL Server unless the user explicitly requests it.**
9. **Prefer reusing a working SQL Server instance over creating another one.**
10. **If a required privileged installation cannot be completed safely, stop and report the missing prerequisite instead of bypassing security controls.**

---

# Phase 0: Inspect Before Changing Anything

From the repository root, inspect the environment:

```bash
pwd
git status
git remote -v
```

Confirm the required files exist:

```bash
test -f "Bicycle Shop Analysis.sqlproj"
test -f "source-data/BikeStores Sample Database - create objects.sql"
test -f "source-data/BikeStores Sample Database - load data.sql"
test -f "database/queries/SELECT.sql"
test -f "database/queries/ORDER_BY.sql"
```

Inspect available tools:

```bash
git --version
dotnet --info
docker --version
docker compose version
sqlcmd -?
```

Some of these commands may fail because the tool is not installed. Record what is available.

Do not install anything until you have determined whether an existing SQL Server instance can be reused.

---

# Phase 1: Find or Provision SQL Server

## Preferred Order

Use the first workable option:

1. an existing local SQL Server 2025 or compatible SQL Server instance,
2. an existing development SQL Server reachable from the current environment,
3. a local SQL Server 2025 Express installation on Windows,
4. a disposable/local SQL Server 2025 Express Docker container on a supported Docker host.

Do not replace a working database server simply because Docker is available.

---

# Option A: Existing SQL Server

If SQL Server is already available, determine:

```text
server/host
port or instance name
authentication method
database credentials, if SQL authentication is used
```

Do not write credentials into the repository.

Verify connectivity using an available SQL client.

For `sqlcmd` with SQL authentication:

```bash
sqlcmd -S "<server>" -U "<user>" -P "<password>" -Q "SELECT @@VERSION;"
```

For Windows authentication where supported:

```powershell
sqlcmd -S "<server>" -E -Q "SELECT @@VERSION;"
```

If connectivity succeeds, continue to **Phase 2**.

---

# Option B: SQL Server 2025 Express on Windows

If running on Windows and SQL Server is not installed, use Microsoft's official SQL Server download source:

```text
https://www.microsoft.com/en-us/sql-server/sql-server-downloads
```

Install SQL Server 2025 Express using the supported Microsoft installer.

After installation:

1. determine the instance name,
2. determine the configured authentication method,
3. verify the instance is running, and
4. verify connectivity.

A common Express instance name is:

```text
localhost\SQLEXPRESS
```

Do not assume this name if the installer created a different instance.

Once connectivity works, continue to **Phase 2**.

---

# Option C: SQL Server 2025 Express with Docker

This is the preferred automated path when Docker is already available and a local SQL Server is not.

## 1. Create a Strong Temporary Password

The SQL Server `sa` password must satisfy SQL Server password complexity requirements.

Use a strong password containing:

- uppercase characters,
- lowercase characters,
- numbers, and
- symbols.

Store it only in the current shell or another local secret mechanism.

Example shell variable:

```bash
export MSSQL_SA_PASSWORD='<strong-password>'
```

Do not commit this value.

## 2. Reuse an Existing Container if Appropriate

Check:

```bash
docker ps -a
```

If a working SQL Server container for this project already exists, reuse it.

Do not create duplicate containers unnecessarily.

## 3. Create Persistent Storage

If no existing project volume is available:

```bash
docker volume create bikestores_sql_data
```

## 4. Start SQL Server

```bash
docker run -d \
  --name bikestores-sql \
  --hostname bikestores-sql \
  -e ACCEPT_EULA=Y \
  -e MSSQL_PID=Express \
  -e MSSQL_SA_PASSWORD="$MSSQL_SA_PASSWORD" \
  -p 127.0.0.1:1433:1433 \
  -v bikestores_sql_data:/var/opt/mssql \
  --restart unless-stopped \
  mcr.microsoft.com/mssql/server:2025-latest
```

If `bikestores-sql` already exists, do not blindly recreate it.

## 5. Wait for SQL Server

Inspect:

```bash
docker ps
docker logs --tail=200 bikestores-sql
```

The container must remain in a running state.

If it enters a restart loop, inspect the logs before changing anything.

Common causes include:

- invalid `sa` password complexity,
- insufficient resources,
- port conflicts, or
- volume permission/configuration problems.

## 6. Verify the Engine

When the container is healthy:

```bash
docker exec bikestores-sql bash -lc \
'/opt/mssql-tools18/bin/sqlcmd -No -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -Q "SELECT @@VERSION;"'
```

If this succeeds, continue.

---

# Phase 2: Create the `BikeStores` Database

Do not assume the database is absent.

First check.

## Docker Path

```bash
docker exec bikestores-sql bash -lc \
'/opt/mssql-tools18/bin/sqlcmd -No -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -Q "SELECT name FROM sys.databases ORDER BY name;"'
```

If `BikeStores` does not exist:

```bash
docker exec bikestores-sql bash -lc \
'/opt/mssql-tools18/bin/sqlcmd -No -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -Q "CREATE DATABASE BikeStores;"'
```

## Generic `sqlcmd` Path

SQL authentication example:

```bash
sqlcmd \
  -S "<server>" \
  -U "<user>" \
  -P "<password>" \
  -Q "IF DB_ID(N'BikeStores') IS NULL CREATE DATABASE BikeStores;"
```

Windows authentication example:

```powershell
sqlcmd `
  -S "<server>" `
  -E `
  -Q "IF DB_ID(N'BikeStores') IS NULL CREATE DATABASE BikeStores;"
```

Do not recreate the database if it already contains the expected BikeStores objects and data.

---

# Phase 3: Determine Whether the Sample Database Is Already Loaded

Run the following against `BikeStores`:

```sql
SELECT DB_NAME() AS CurrentDatabase;

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_SCHEMA, TABLE_NAME;

SELECT
    CASE
        WHEN OBJECT_ID(N'production.products', N'U') IS NOT NULL THEN 1
        ELSE 0
    END AS ProductsTableExists,
    CASE
        WHEN OBJECT_ID(N'sales.orders', N'U') IS NOT NULL THEN 1
        ELSE 0
    END AS OrdersTableExists;
```

If the expected tables already exist, do **not** rerun the create-objects script.

If the tables exist and contain data, skip directly to **Phase 5**.

If tables exist but data is absent, run only the load-data script if doing so will not create duplicate rows.

If the database is in an unknown partial state, report it before performing destructive cleanup.

---

# Phase 4: Load the BikeStores Schema and Data

## Docker Path

Copy the source scripts into the running container:

```bash
docker exec bikestores-sql mkdir -p /tmp/bikestores
docker cp "source-data/BikeStores Sample Database - create objects.sql" \
  "bikestores-sql:/tmp/bikestores/create-objects.sql"
docker cp "source-data/BikeStores Sample Database - load data.sql" \
  "bikestores-sql:/tmp/bikestores/load-data.sql"
```

Create objects:

```bash
docker exec bikestores-sql bash -lc \
'/opt/mssql-tools18/bin/sqlcmd -No -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -d BikeStores -b -i "/tmp/bikestores/create-objects.sql"'
```

Load sample data:

```bash
docker exec bikestores-sql bash -lc \
'/opt/mssql-tools18/bin/sqlcmd -No -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -d BikeStores -b -i "/tmp/bikestores/load-data.sql"'
```

The `-b` option is important because it causes `sqlcmd` to return a failure status when the SQL script encounters an error.

## Generic `sqlcmd` Path

Run the scripts explicitly against `BikeStores`.

SQL authentication example:

```bash
sqlcmd \
  -S "<server>" \
  -U "<user>" \
  -P "<password>" \
  -d BikeStores \
  -b \
  -i "source-data/BikeStores Sample Database - create objects.sql"
```

Then:

```bash
sqlcmd \
  -S "<server>" \
  -U "<user>" \
  -P "<password>" \
  -d BikeStores \
  -b \
  -i "source-data/BikeStores Sample Database - load data.sql"
```

For Windows authentication, replace the username/password arguments with `-E`.

Always pass `-d BikeStores`. The source scripts create objects but do not create or select the `BikeStores` database themselves.

---

# Phase 5: Validate the Database

Run all of the following against `BikeStores`.

## Confirm Database Context

```sql
SELECT DB_NAME() AS CurrentDatabase;
```

Expected:

```text
BikeStores
```

## Confirm Schemas

```sql
SELECT name
FROM sys.schemas
WHERE name IN ('production', 'sales')
ORDER BY name;
```

Expected:

```text
production
sales
```

## Confirm Base Tables

```sql
SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_SCHEMA IN ('production', 'sales')
ORDER BY TABLE_SCHEMA, TABLE_NAME;
```

Expected BikeStores tables:

```text
production.brands
production.categories
production.products
production.stocks
sales.customers
sales.order_items
sales.orders
sales.staffs
sales.stores
```

Expected count:

```text
9
```

## Confirm Sample Data

```sql
SELECT COUNT(*) AS ProductCount
FROM production.products;

SELECT COUNT(*) AS OrderCount
FROM sales.orders;

SELECT TOP (5)
    product_id,
    product_name,
    model_year,
    list_price
FROM production.products
ORDER BY product_id;
```

`ProductCount` and `OrderCount` must both be greater than zero.

Do not hardcode a row-count expectation unless it has been verified from the source data currently in this repository.

---

# Phase 6: Prepare the SQL Database Project

Project file:

```text
Bicycle Shop Analysis.sqlproj
```

Inspect it before modifying anything.

The current project uses `Microsoft.Build.Sql`.

Check .NET:

```bash
dotnet --info
```

If a compatible .NET SDK is already installed:

```bash
dotnet restore "Bicycle Shop Analysis.sqlproj"
dotnet build "Bicycle Shop Analysis.sqlproj"
```

If the SDK is missing and installation is safe and permitted, install a supported .NET SDK from Microsoft's official source, then rerun the commands.

If the build fails:

1. capture the exact error,
2. determine whether the failure is an environment problem or a project problem,
3. do not make unrelated source changes to force a green build, and
4. report any project change required to fix the build.

A successful build is a validation step. It does not populate or modify the live `BikeStores` database.

---

# Phase 7: Inspect and Execute the SQL Work

Current query files:

```text
database/queries/SELECT.sql
database/queries/ORDER_BY.sql
```

Execute them only against `BikeStores`.

Before execution:

```sql
SELECT DB_NAME() AS CurrentDatabase;
```

Expected:

```text
BikeStores
```

If using `sqlcmd`, an example is:

```bash
sqlcmd \
  -S "<server>" \
  -U "<user>" \
  -P "<password>" \
  -d BikeStores \
  -b \
  -i "database/queries/SELECT.sql"
```

Then:

```bash
sqlcmd \
  -S "<server>" \
  -U "<user>" \
  -P "<password>" \
  -d BikeStores \
  -b \
  -i "database/queries/ORDER_BY.sql"
```

For Windows authentication, use `-E`.

The purpose of this phase is validation and inspection. Do not rewrite the queries unless the user asks for changes.

---

# Phase 8: Report Completion

At completion, report all of the following:

```text
Repository:
SQL Server version:
Connection target:
Database:
Schemas found:
Base table count:
Product row count:
Order row count:
SQL project build status:
SELECT.sql execution status:
ORDER_BY.sql execution status:
Files modified during setup:
Outstanding issues:
```

Do not claim setup is complete if any required validation failed.

---

# Optional Cleanup

Do **not** perform cleanup unless explicitly requested.

## Docker Container

To stop the container without deleting database storage:

```bash
docker stop bikestores-sql
```

To start it again:

```bash
docker start bikestores-sql
```

Do not delete `bikestores_sql_data` unless the user explicitly requests removal of the database data.

## SQL Database

If the user explicitly requests complete database removal:

```sql
USE master;

ALTER DATABASE BikeStores
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;

DROP DATABASE BikeStores;
```

Do not run this during normal inspection.

---

# Ready-to-Copy Coding Agent Prompt

Copy the following into an agentic coding assistant from the repository root:

```text
Prepare this repository for local inspection by following AGENTS_README.md as the source of truth.

Goal:
Produce a working local Bicycle Shop Analysis environment backed by the BikeStores SQL Server database.

Rules:
- Inspect the current environment before installing or changing anything.
- Reuse an existing working SQL Server instance when possible.
- If no SQL Server is available and Docker is available, use the Docker setup documented in AGENTS_README.md.
- Do not delete databases, Docker volumes, files, branches, or user configuration.
- Do not run the drop-all-objects script unless I explicitly request a reset.
- Do not commit credentials or generated database files.
- Do not rewrite analytical SQL merely to make setup pass.
- Do not publish schema changes to a remote database.
- Keep all setup changes minimal and report every repository file you modify.

Required work:
1. Inspect the repository and available tooling.
2. Ensure a working SQL Server instance is available.
3. Ensure a database named BikeStores exists.
4. Determine whether the BikeStores schema and data are already loaded.
5. If needed, run the source-data create-objects script against BikeStores.
6. If needed, run the source-data load-data script against BikeStores.
7. Run every validation query documented in AGENTS_README.md.
8. Build "Bicycle Shop Analysis.sqlproj" if the required .NET tooling is available or can be installed safely.
9. Validate the SQL files under database/queries against BikeStores.
10. Do not perform cleanup after validation.

Before finishing, report:
- SQL Server version
- connection target
- database name
- schemas discovered
- base table count
- product row count
- order row count
- SQL project build result
- query validation result
- files modified
- anything that could not be completed

Do not say the project is ready until the validation checks in AGENTS_README.md pass.
```

---

# Notes for Agents

This repository is a learning and portfolio project.

Preserve evidence of the author's work.

Your role during setup is to make the existing project inspectable and reproducible, not to replace the author's SQL with generated alternatives.
