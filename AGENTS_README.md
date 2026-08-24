# Repository Setup Runbook

## Purpose

This file defines the safe, reproducible setup and validation procedure for the Bicycle Shop Analysis repository. It is written for automated tools and contributors preparing the project for local inspection.

The project root is the repository root:

```text
bicycle-shop-analysis/
```

Human-oriented project documentation is in [`README.md`](./README.md).

## Required End State

Setup is complete only when all applicable checks below have passed:

- SQL Server is running and reachable.
- A database named `BikeStores` exists.
- The `production`, `sales`, and project-specific `hr` schemas exist.
- The nine BikeStores base tables and two HR demonstration tables exist.
- `production.products` and `sales.orders` contain rows.
- `hr.candidates` and `hr.employees` each contain four deterministic rows.
- `Bicycle Shop Analysis.sqlproj` builds when a compatible .NET SDK is available.
- All checked-in files under `database/queries/` execute against `BikeStores`; `JOIN.sql` requires the HR setup script.

Do not modify analytical SQL or documentation merely to make setup appear successful. Report missing prerequisites and validation failures accurately.

## Repository Facts

Important files, relative to the project root:

```text
Bicycle Shop Analysis.sqlproj

database/queries/*.sql

source-data/BikeStores Sample Database - create objects.sql
source-data/BikeStores Sample Database - load data.sql
source-data/BikeStores Sample Database - drop all objects.sql
source-data/BikeStores Sample Database - Create HR schema and tables.sql
```

Project configuration:

```text
Build SDK:       Microsoft.Build.Sql 2.2.0
Schema provider: Microsoft.Data.Tools.Schema.Sql.Sql170DatabaseSchemaProvider
Target platform: SQL Server 2025
Database name:   BikeStores
Schemas:         production, sales, hr
```

The lowercase-named BikeStores scripts are upstream sample assets. `BikeStores Sample Database - Create HR schema and tables.sql` is a project-specific, rerunnable fixture for the join examples; it creates `hr` when needed and drops and recreates only `hr.candidates` and `hr.employees`.

The SQL project and live sample database have different roles. Building the project validates and packages source-controlled SQL; it does not create, populate, or publish the live database.

## Safety Rules

1. Do not delete an existing database unless the user explicitly requests it.
2. Do not run the drop-all-objects script during routine setup.
3. Do not run destructive Docker commands such as `docker compose down -v`, `docker volume rm`, or broad prune commands.
4. Do not commit passwords, secret-bearing connection strings, backups, database files, or generated build output.
5. Do not modify the three upstream BikeStores scripts under `source-data/` unless correcting a verified defect. The HR script is project-authored demonstration setup.
6. Do not rewrite analytical SQL to satisfy a stylistic preference or conceal a setup failure.
7. Do not force-push, reset Git history, delete branches, or publish the project to a remote database without explicit authorization.
8. Prefer an existing working SQL Server instance over provisioning another one.
9. If the database is partially initialized or its state is uncertain, report that state before attempting destructive recovery.
10. If a privileged installation is unavailable or unsafe, report the missing prerequisite instead of bypassing system controls.
11. Do not run the HR setup script when existing changes in `hr.candidates` or `hr.employees` must be retained; it drops and recreates both tables.

## Phase 1: Inspect the Repository and Environment

Run these commands from `bicycle-shop-analysis/`:

```bash
pwd
git status --short --branch
git remote -v
```

Confirm the required files:

```bash
test -f "Bicycle Shop Analysis.sqlproj"
test -f "source-data/BikeStores Sample Database - create objects.sql"
test -f "source-data/BikeStores Sample Database - load data.sql"
test -f "source-data/BikeStores Sample Database - Create HR schema and tables.sql"
test -f "database/queries/SELECT.sql"
test -f "database/queries/ORDER_BY.sql"
test -f "database/queries/JOIN.sql"
```

Inspect available tools without assuming they are installed:

```bash
git --version
dotnet --info
docker --version
docker compose version
sqlcmd -?
```

Record unavailable commands. Do not install anything until checking whether an existing SQL Server instance can be reused.

## Phase 2: Find or Provision SQL Server

Use the first suitable option:

1. an existing local compatible SQL Server instance,
2. an existing development instance reachable from the current environment,
3. SQL Server 2025 Express installed on Windows, or
4. a local SQL Server 2025 container on a supported Docker host.

### Existing SQL Server

Determine the host, port or instance name, authentication method, and database credentials. Keep credentials outside the repository.

With SQL authentication:

```bash
sqlcmd -S "<server>" -U "<user>" -P "<password>" -b -Q "SELECT @@VERSION;"
```

With Windows authentication where supported:

```powershell
sqlcmd -S "<server>" -E -b -Q "SELECT @@VERSION;"
```

Continue only after connectivity succeeds.

### SQL Server 2025 Express on Windows

Use Microsoft's [SQL Server downloads](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) and supported installer. Record the configured instance name and authentication method; do not assume the instance is `localhost\SQLEXPRESS` without verifying it.

### SQL Server 2025 with Docker

Use this path only when Docker is already available and no suitable server can be reused.

Create a strong temporary `sa` password and keep it in the current shell or another local secret store:

```bash
export MSSQL_SA_PASSWORD='<strong-password>'
```

Check for an existing project container and volume before creating either:

```bash
docker ps -a
docker volume ls
```

If neither exists, create persistent storage and start the server:

```bash
docker volume create bikestores_sql_data

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

Inspect startup rather than relying on a fixed sleep:

```bash
docker ps
docker logs --tail=200 bikestores-sql
```

Verify the engine from inside the container:

```bash
docker exec bikestores-sql bash -lc \
  '/opt/mssql-tools18/bin/sqlcmd -No -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -b -Q "SELECT @@VERSION;"'
```

If the container does not remain running, inspect its logs for password-complexity failures, port conflicts, resource limits, or storage errors before changing anything.

## Phase 3: Create or Inspect `BikeStores`

Do not assume the database is absent. Query the server first:

```sql
SELECT name
FROM sys.databases
WHERE name = N'BikeStores';
```

Create it only when it does not exist:

```sql
IF DB_ID(N'BikeStores') IS NULL
BEGIN
    CREATE DATABASE BikeStores;
END;
```

Generic `sqlcmd` example:

```bash
sqlcmd \
  -S "<server>" \
  -U "<user>" \
  -P "<password>" \
  -b \
  -Q "IF DB_ID(N'BikeStores') IS NULL CREATE DATABASE BikeStores;"
```

For Windows authentication, replace `-U` and `-P` with `-E`.

Docker example:

```bash
docker exec bikestores-sql \
  /opt/mssql-tools18/bin/sqlcmd \
  -No \
  -S localhost \
  -U sa \
  -P "$MSSQL_SA_PASSWORD" \
  -b \
  -Q "IF DB_ID(N'BikeStores') IS NULL CREATE DATABASE BikeStores;"
```

Inspect the database before loading anything:

```sql
SELECT DB_NAME() AS CurrentDatabase;

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_SCHEMA IN (N'hr', N'production', N'sales')
ORDER BY
    TABLE_SCHEMA,
    TABLE_NAME;

SELECT
    CASE WHEN OBJECT_ID(N'production.products', N'U') IS NULL THEN 0 ELSE 1 END AS ProductsTableExists,
    CASE WHEN OBJECT_ID(N'sales.orders', N'U') IS NULL THEN 0 ELSE 1 END AS OrdersTableExists,
    CASE WHEN OBJECT_ID(N'hr.candidates', N'U') IS NULL THEN 0 ELSE 1 END AS CandidatesTableExists,
    CASE WHEN OBJECT_ID(N'hr.employees', N'U') IS NULL THEN 0 ELSE 1 END AS EmployeesTableExists;
```

- If all expected tables and data already exist, do not reload them.
- If the nine BikeStores tables exist but the HR tables do not, run only the HR setup step in Phase 4.
- If no expected objects exist, continue through all of Phase 4.
- If only some BikeStores objects exist, stop and report the partial state before considering a reset.
- If tables exist without data, confirm the load script will not duplicate existing rows before running it.

## Phase 4: Load the Schema and Data

The source scripts create objects and insert rows, but they do not create or select `BikeStores`. Always connect with `-d BikeStores`.

### Generic `sqlcmd`

```bash
sqlcmd \
  -S "<server>" \
  -U "<user>" \
  -P "<password>" \
  -d BikeStores \
  -b \
  -i "source-data/BikeStores Sample Database - create objects.sql"

sqlcmd \
  -S "<server>" \
  -U "<user>" \
  -P "<password>" \
  -d BikeStores \
  -b \
  -i "source-data/BikeStores Sample Database - load data.sql"

sqlcmd \
  -S "<server>" \
  -U "<user>" \
  -P "<password>" \
  -d BikeStores \
  -b \
  -i "source-data/BikeStores Sample Database - Create HR schema and tables.sql"
```

For Windows authentication, replace `-U` and `-P` with `-E`.

### Docker

Copy the scripts into the container:

```bash
docker exec bikestores-sql mkdir -p /tmp/bikestores
docker cp "source-data/BikeStores Sample Database - create objects.sql" \
  "bikestores-sql:/tmp/bikestores/create-objects.sql"
docker cp "source-data/BikeStores Sample Database - load data.sql" \
  "bikestores-sql:/tmp/bikestores/load-data.sql"
docker cp "source-data/BikeStores Sample Database - Create HR schema and tables.sql" \
  "bikestores-sql:/tmp/bikestores/create-hr.sql"
```

Run all three scripts against `BikeStores`:

```bash
docker exec bikestores-sql bash -lc \
  '/opt/mssql-tools18/bin/sqlcmd -No -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -d BikeStores -b -i "/tmp/bikestores/create-objects.sql"'

docker exec bikestores-sql bash -lc \
  '/opt/mssql-tools18/bin/sqlcmd -No -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -d BikeStores -b -i "/tmp/bikestores/load-data.sql"'

docker exec bikestores-sql bash -lc \
  '/opt/mssql-tools18/bin/sqlcmd -No -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -d BikeStores -b -i "/tmp/bikestores/create-hr.sql"'
```

The `-b` flag makes `sqlcmd` return a failure status when SQL execution fails. The HR script is intentionally rerunnable, but every run replaces the two HR demonstration tables and their contents.

## Phase 5: Validate the Database

Run every check against `BikeStores`.

```sql
SELECT DB_NAME() AS CurrentDatabase;

SELECT name
FROM sys.schemas
WHERE name IN (N'hr', N'production', N'sales')
ORDER BY name;

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_SCHEMA IN (N'hr', N'production', N'sales')
ORDER BY
    TABLE_SCHEMA,
    TABLE_NAME;

SELECT COUNT(*) AS ProductCount
FROM production.products;

SELECT COUNT(*) AS OrderCount
FROM sales.orders;

SELECT COUNT(*) AS CandidateCount
FROM hr.candidates;

SELECT COUNT(*) AS EmployeeCount
FROM hr.employees;

SELECT TOP (5)
    product_id,
    product_name,
    model_year,
    list_price
FROM production.products
ORDER BY product_id;
```

Expected context and structure:

```text
Database: BikeStores
Schemas:  hr, production, sales

hr.candidates
hr.employees
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

There should be 11 relevant base tables: nine from BikeStores and two from the project-specific HR fixture. `ProductCount` and `OrderCount` must both be greater than zero. `CandidateCount` and `EmployeeCount` should each be four after the checked-in HR script runs; do not claim exact BikeStores row counts unless the checked-in source data has been used and the counts were measured.

## Phase 6: Build the SQL Project

Inspect the project before changing it:

```bash
dotnet --info
dotnet build "Bicycle Shop Analysis.sqlproj"
```

If `dotnet` is unavailable, report the missing prerequisite. If the build fails, capture the exact error and distinguish an environment failure from a project failure before proposing changes.

A successful build produces a DACPAC under `bin/`. It does not modify the live `BikeStores` database.

## Phase 7: Validate the Query Files

Execute every checked-in query file only against a database that has completed both the BikeStores and HR setup. On a POSIX shell, the generic `sqlcmd` validation loop is:

```bash
for query_file in database/queries/*.sql; do
  sqlcmd \
    -S "<server>" \
    -U "<user>" \
    -P "<password>" \
    -d BikeStores \
    -b \
    -i "$query_file" || exit 1
done
```

For Windows authentication, replace `-U` and `-P` with `-E`. On shells that do not support this loop, run the files individually with the same `sqlcmd` options. When using Docker, copy the query files into the container and use the same `sqlcmd` pattern documented in Phase 4. `JOIN.sql` will fail if the HR fixture was skipped.

The purpose is validation. Do not rewrite a query unless the user asks for a query change or a verified defect requires correction.

## Completion Report

Report each item explicitly:

```text
Repository root:
SQL Server version:
Connection target:
Database:
Schemas found:
Base table count:
Product row count:
Order row count:
Candidate row count:
Employee row count:
SQL project build status:
Query files execution status:
Files modified during setup:
Outstanding issues:
```

Do not report the project as ready if a required validation failed. An unavailable optional tool should be identified precisely rather than presented as a successful check.

## Optional Cleanup

Do not perform cleanup unless the user explicitly requests it.

Stop and restart the project container without deleting its volume:

```bash
docker stop bikestores-sql
docker start bikestores-sql
```

If the user explicitly requests deletion of the local database:

```sql
USE master;

ALTER DATABASE BikeStores
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;

DROP DATABASE BikeStores;
```

Deleting the database is irreversible unless a backup exists. Never delete `bikestores_sql_data` as part of routine review or cleanup.
