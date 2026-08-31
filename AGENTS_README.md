# Repository Setup Runbook

## Purpose

This runbook defines the safe, reproducible setup and validation procedure for the Bicycle Shop Analysis repository. It is intended for contributors and automated tools preparing the project for local inspection. Human-oriented project documentation is in [`README.md`](./README.md).

Run all commands from the repository root:

```text
bicycle-shop-analysis/
```

## Required End State

Setup is complete only when all applicable checks have passed:

- SQL Server is running and reachable.
- A database named `BikeStores` exists.
- The `production`, `sales`, `hr`, and `pm` schemas exist.
- All 15 base tables defined by the checked-in schema exist when the setup user's default schema is `dbo`.
- `production.products` and `sales.orders` contain rows.
- `hr.candidates` and `hr.employees` contain four rows each.
- `pm.projects` contains three rows and `pm.members` contains four rows.
- `dbo.companies` and `dbo.product_json` contain three rows each.
- `Bicycle Shop Analysis.sqlproj` builds when a compatible .NET SDK is available.
- Every completed file under `database/queries/basic/` and `database/queries/advanced/` executes against `BikeStores`.

`database/queries/advanced/ADV_CROSS_JOIN.sql` is planned work and currently contains comments only, so it has no executable validation requirement. `database/queries/advanced/ADV_CROSS_APPLY.sql` is executable and creates or alters `GetTopProductsByCategory` as part of its demonstration.

Do not modify analytical SQL or documentation merely to make setup appear successful. Report missing prerequisites and validation failures accurately.

## Repository Facts

Important paths, relative to the project root:

```text
Bicycle Shop Analysis.sqlproj
.vscode/tasks.json

database/queries/basic/*.sql
database/queries/advanced/*.sql
database/schema/BikeStores Sample Database - create objects.sql
database/seed/BikeStores Sample Database - load data.sql
database/utilities/BikeStores Sample Database - drop all objects.sql
```

Project configuration:

```text
Build SDK:       Microsoft.Build.Sql 2.2.0
Schema provider: Microsoft.Data.Tools.Schema.Sql.Sql170DatabaseSchemaProvider
Target platform: SQL Server 2025
Database name:   BikeStores
Schemas:         production, sales, hr, pm; helper tables use the default schema
Base tables:     15 when the setup user's default schema is dbo
```

The schema and seed scripts adapt the attributed BikeStores sample and add deterministic HR, project-management, company-name, and JSON fixtures used by the query examples. The `companies` and `product_json` tables are unqualified in the scripts, so the documented setup requires a database user whose default schema is `dbo`. The scripts target a clean `BikeStores` database. The schema script creates tables without first dropping existing tables, and the seed script inserts fixed identifiers and fixture rows; neither is a routine migration or an idempotent reload.

The SQL project and live sample database have different roles. Building the project validates and packages source-controlled SQL; it does not create, populate, publish, or modify the live database.

## Safety Rules

1. Do not delete an existing database unless the user explicitly requests it.
2. Do not run the drop-all-objects utility during routine setup. It is destructive and currently performs only a partial cleanup: it does not remove `companies`, `product_json`, or `GetTopProductsByCategory`.
3. Do not load the schema or seed scripts over a partial or populated database.
4. Do not run destructive Docker commands such as `docker compose down -v`, `docker volume rm`, or broad prune commands.
5. Do not commit passwords, secret-bearing connection strings, backups, database files, or generated build output.
6. Preserve upstream attribution and do not change attributed sample data unless correcting a verified defect.
7. Do not rewrite analytical SQL to satisfy a stylistic preference or conceal a setup failure.
8. Do not force-push, reset Git history, delete branches, or publish the project to a remote database without explicit authorization.
9. Prefer an existing working SQL Server instance over provisioning another one.
10. If the database is partially initialized or its state is uncertain, report that state before considering a reset.
11. If a privileged installation is unavailable or unsafe, report the missing prerequisite instead of bypassing system controls.

## Phase 1: Inspect the Repository and Environment

```bash
pwd
git status --short --branch
git remote -v
```

Confirm the key files:

```bash
test -f "Bicycle Shop Analysis.sqlproj"
test -f "database/schema/BikeStores Sample Database - create objects.sql"
test -f "database/seed/BikeStores Sample Database - load data.sql"
test -f "database/utilities/BikeStores Sample Database - drop all objects.sql"
test -f "database/queries/basic/SELECT.sql"
test -f "database/queries/basic/SUBQUERY.sql"
test -f "database/queries/basic/JOIN.sql"
test -f "database/queries/advanced/ADV_SELF_JOIN.sql"
test -f "database/queries/advanced/ADV_CROSS_APPLY.sql"
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

1. an existing local compatible SQL Server instance;
2. an existing development instance reachable from the current environment;
3. SQL Server 2025 Express installed on Windows; or
4. a local SQL Server 2025 container on a supported Docker host.

### Existing SQL Server

Determine the host, port or instance name, authentication method, and database credentials. Keep credentials outside the repository.

With SQL authentication, set the password in the current shell so it is not embedded in the command:

```bash
export SQLCMDPASSWORD='<password>'
sqlcmd -S "<server>" -U "<user>" -b -Q "SELECT @@VERSION;"
```

With Windows authentication where supported:

```powershell
sqlcmd -S "<server>" -E -b -Q "SELECT @@VERSION;"
```

Continue only after connectivity succeeds.

### SQL Server 2025 Express on Windows

Use Microsoft's [SQL Server downloads](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) and supported installer. Record the configured instance name and authentication method; do not assume the instance is `localhost\SQLEXPRESS` without verifying it.

### SQL Server 2025 with Docker

Use this path only when Docker is already available and no suitable server can be reused. Create a strong temporary `sa` password and keep it outside the repository:

```bash
export MSSQL_SA_PASSWORD='<strong-password>'
docker ps -a
docker volume ls
```

If no existing project container or volume can be reused:

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

docker exec bikestores-sql bash -lc \
  '/opt/mssql-tools18/bin/sqlcmd -No -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -b -Q "SELECT @@VERSION;"'
```

If the container does not remain running, inspect its logs for password-complexity failures, port conflicts, resource limits, or storage errors before changing anything.

## Phase 3: Inspect or Create `BikeStores`

Do not assume the database is absent:

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

Generic command-line example:

```bash
sqlcmd \
  -S "<server>" \
  -U "<user>" \
  -b \
  -Q "IF DB_ID(N'BikeStores') IS NULL CREATE DATABASE BikeStores;"
```

For Windows authentication, replace `-U "<user>"` with `-E`.

Inspect the database before loading anything:

```sql
USE BikeStores;

SELECT
    USER_NAME() AS DatabaseUser,
    SCHEMA_NAME() AS DefaultSchema;

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_SCHEMA IN (N'dbo', N'hr', N'pm', N'production', N'sales')
ORDER BY
    TABLE_SCHEMA,
    TABLE_NAME;
```

- Continue only when `DefaultSchema` is `dbo`; the current helper tables and function use unqualified names.
- If no project tables exist, continue through Phase 4.
- If all expected tables and data already exist, skip loading and continue to validation.
- If only some objects exist, stop and report the partial state before considering a reset.
- If tables exist without data, do not assume the seed script is safe to rerun; it uses fixed identifiers and can conflict with existing rows.

## Phase 4: Load the Schema and Data

The supported clean setup has two steps. The examples below use `SQLCMDPASSWORD` from the current shell:

```bash
sqlcmd \
  -S "<server>" \
  -U "<user>" \
  -d BikeStores \
  -b \
  -i "database/schema/BikeStores Sample Database - create objects.sql"

sqlcmd \
  -S "<server>" \
  -U "<user>" \
  -d BikeStores \
  -b \
  -i "database/seed/BikeStores Sample Database - load data.sql"
```

For Windows authentication, replace `-U "<user>"` with `-E`.

For a Docker-hosted server, copy and run the same two scripts:

```bash
docker exec bikestores-sql mkdir -p /tmp/bikestores
docker cp "database/schema/BikeStores Sample Database - create objects.sql" \
  "bikestores-sql:/tmp/bikestores/create-objects.sql"
docker cp "database/seed/BikeStores Sample Database - load data.sql" \
  "bikestores-sql:/tmp/bikestores/load-data.sql"

docker exec bikestores-sql bash -lc \
  '/opt/mssql-tools18/bin/sqlcmd -No -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -d BikeStores -b -i "/tmp/bikestores/create-objects.sql"'

docker exec bikestores-sql bash -lc \
  '/opt/mssql-tools18/bin/sqlcmd -No -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -d BikeStores -b -i "/tmp/bikestores/load-data.sql"'
```

The `-b` flag makes `sqlcmd` return a failure status when SQL execution fails.

## Phase 5: Validate the Database

Run every check against `BikeStores`:

```sql
SELECT DB_NAME() AS CurrentDatabase;

SELECT name
FROM sys.schemas
WHERE name IN (N'hr', N'pm', N'production', N'sales')
ORDER BY name;

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_SCHEMA IN (N'hr', N'pm', N'production', N'sales')
ORDER BY
    TABLE_SCHEMA,
    TABLE_NAME;

SELECT COUNT(*) AS ProductCount FROM production.products;
SELECT COUNT(*) AS OrderCount FROM sales.orders;
SELECT COUNT(*) AS CandidateCount FROM hr.candidates;
SELECT COUNT(*) AS EmployeeCount FROM hr.employees;
SELECT COUNT(*) AS ProjectCount FROM pm.projects;
SELECT COUNT(*) AS MemberCount FROM pm.members;
SELECT COUNT(*) AS CompanyCount FROM dbo.companies;
SELECT COUNT(*) AS JsonProductCount FROM dbo.product_json;
```

Expected structure and fixture counts:

```text
Database:       BikeStores
Default schema: dbo
Schemas:        hr, pm, production, sales
Base tables:    15
Products:       greater than zero
Orders:         greater than zero
Candidates:     4
Employees:      4
Projects:       3
Members:        4
Companies:      3
JSON products:  3
```

Do not claim exact upstream BikeStores row counts unless the checked-in seed data was used and the counts were measured.

## Phase 6: Build the SQL Project

```bash
dotnet --info
dotnet build "Bicycle Shop Analysis.sqlproj"
```

If `dotnet` is unavailable, report the missing prerequisite. If the build fails, capture the exact error and distinguish an environment failure from a project failure before proposing changes. A successful build produces a DACPAC under `bin/`; it does not modify the live database.

## Phase 7: Validate the Query Files

Execute every completed query only after the database passes Phase 5. On a POSIX shell:

```bash
find database/queries/basic database/queries/advanced \
  -type f -name '*.sql' \
  ! -name 'ADV_CROSS_JOIN.sql' \
  -print0 |
while IFS= read -r -d '' query_file; do
  sqlcmd \
    -S "<server>" \
    -U "<user>" \
    -d BikeStores \
    -b \
    -i "$query_file" || exit 1
done
```

For Windows authentication, replace `-U "<user>"` with `-E`. On shells that do not support this loop, run the files individually with the same options. When using Docker, copy both query directories into the container and use the same `sqlcmd` pattern documented in Phase 4.

For SQL-authenticated connections, VS Code provides equivalent `BikeStores: Validate database` and `Queries: Run portfolio queries` tasks. Both prompt for connection values, and the query task explicitly lists every completed query while excluding the comment-only `ADV_CROSS_JOIN.sql`. Use the documented command-line path for Windows authentication.

Most query files are read-only. `ADV_CROSS_APPLY.sql` creates or alters `GetTopProductsByCategory` before running its examples, so validation of every completed file makes that intentional schema change. Its unqualified helper-object references also assume the same default schema used during setup.

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
Project row count:
Member row count:
Company row count:
JSON product row count:
SQL project build status:
Completed query files execution status:
Files modified during setup:
Outstanding issues:
```

Do not report the project as ready if a required validation failed. Identify an unavailable optional tool precisely rather than presenting it as a successful check.

## Optional Cleanup

Do not perform cleanup unless the user explicitly requests it.

```bash
docker stop bikestores-sql
docker start bikestores-sql
```

The checked-in utility drops the 13 tables under `hr`, `pm`, `production`, and `sales`, then drops those four schemas. It does not remove the current default-schema `companies` and `product_json` tables or the `GetTopProductsByCategory` function, so it is not a complete reset. It is destructive and should be run only against the intended `BikeStores` database as part of explicitly authorized partial cleanup:

```bash
sqlcmd \
  -S "<server>" \
  -U "<user>" \
  -d BikeStores \
  -b \
  -i "database/utilities/BikeStores Sample Database - drop all objects.sql"
```

Dropping the objects is irreversible unless a backup exists. Never delete `bikestores_sql_data` as part of routine review or cleanup.
