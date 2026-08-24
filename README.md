# Bicycle Shop Analysis

A SQL Server portfolio project built on the BikeStores sample database. It is a growing collection of focused `.sql` files that demonstrate how I use different T-SQL features, from foundational syntax through increasingly advanced querying and analysis.

The repository supports two review paths:

1. Browse the SQL files and project history directly on GitHub.
2. Recreate the BikeStores database locally and run the queries against live sample data.

## Project Status

The current phase focuses on foundational querying. The repository contains working examples for `SELECT`, filtering, sorting, grouping, aggregation, subqueries, aliases, and an introductory `INNER JOIN`. Each concept is kept in a focused file so the code is easy to review and the progression is visible over time.

## Current Topics

- Selecting and filtering data
- Sorting and grouping results
- Aggregate functions and `HAVING`
- Aliases, range predicates, pattern matching, and subqueries
- An `INNER JOIN` example backed by deterministic HR demonstration data
- Clear, commented examples of individual SQL methods
- SQL Database Project organization and builds
- Reproducible sample-database setup
- Git-based project history

Planned showcase work includes additional join types, common table expressions, window functions, views, stored procedures, functions, data validation, indexing, and query-performance techniques. More involved business analysis can be added later when it goes beyond demonstrating a single SQL concept.

## Technology

- Microsoft SQL Server 2025 Express
- T-SQL
- Visual Studio Code
- SQL Server (`mssql`) extension for Visual Studio Code
- SQL Database Projects extension for Visual Studio Code
- Microsoft.Build.Sql 2.2.0
- Git and GitHub

The SQL project targets the SQL Server 2025 (`Sql170`) schema provider. My development instance runs in Docker on an Ubuntu Server VM, but any compatible SQL Server instance can be used to review the project.

## Data Source

This project uses the [BikeStores sample database](https://www.sqlservertutorial.net/getting-started/sql-server-sample-database/) from SQLServerTutorial.net. The original BikeStores setup scripts are retained in [`source-data/`](./source-data/); they are upstream sample data, not original analytical work. The same directory also contains a project-specific, rerunnable HR setup script that supplies the small deterministic data set used by `JOIN.sql`.

The live demonstration database uses three relevant schemas:

- `production`
- `sales`
- `hr`, containing the project-specific `candidates` and `employees` demonstration tables

## Repository Structure

```text
bicycle-shop-analysis/
├── .vscode/
│   ├── settings.json
│   └── tasks.json
├── database/
│   └── queries/
│       ├── JOIN.sql
│       ├── SELECT.sql
│       └── ... additional focused concept files
├── source-data/
│   ├── BikeStores Sample Database - Create HR schema and tables.sql
│   ├── BikeStores Sample Database - create objects.sql
│   ├── BikeStores Sample Database - drop all objects.sql
│   └── BikeStores Sample Database - load data.sql
├── AGENTS_README.md
├── Bicycle Shop Analysis.sqlproj
└── README.md
```

### SQL showcase files

- [`SELECT.sql`](./database/queries/SELECT.sql) demonstrates projection, filtering, sorting, grouping, aggregation, and `HAVING`.
- [`ORDER_BY.sql`](./database/queries/ORDER_BY.sql) demonstrates ascending and descending sorts, multiple sort keys, ordinal positions, nonprojected columns, and expressions.
- [`IN_SUBQUERY.sql`](./database/queries/IN_SUBQUERY.sql) demonstrates list membership and a nested query against stock data.
- [`JOIN.sql`](./database/queries/JOIN.sql) uses `hr.candidates` and `hr.employees` to answer which candidates were hired with an `INNER JOIN`.

New concept demonstrations belong in `database/queries/`. The current structure intentionally keeps these examples together; a separate analysis area is only needed once the repository contains longer, multi-step investigations organized around business questions rather than individual SQL features.

### SQL project

[`Bicycle Shop Analysis.sqlproj`](./Bicycle%20Shop%20Analysis.sqlproj) is an SDK-style Microsoft.Build.Sql project. A build validates the project and produces a DACPAC; it does not create or populate the live `BikeStores` database.

### Setup runbook

[`AGENTS_README.md`](./AGENTS_README.md) contains the detailed environment, command-line, Docker, validation, safety, and cleanup procedures used to reproduce the project consistently.

## Review the SQL

### Browse on GitHub

The SQL, comments, project configuration, sample setup scripts, and Git history can all be inspected without installing SQL Server. The repository can also be browsed through [VS Code for the Web](https://vscode.dev/github/Znovak2/sql-portfolio).

Start with the files under [`database/queries/`](./database/queries/). Executing them is optional and requires a populated `BikeStores` database.

### Run the queries live

Follow the local setup below to create `BikeStores`, load the sample data, and execute the same showcase files against SQL Server. For a command-line or Docker-based setup, use the more detailed [`AGENTS_README.md`](./AGENTS_README.md) runbook.

## Local Setup

### 1. Clone the repository

```bash
git clone https://github.com/Znovak2/sql-portfolio.git bicycle-shop-analysis
cd bicycle-shop-analysis
```

All commands below assume `bicycle-shop-analysis/` is the current directory.

### 2. Install the tools

Install or make available:

- a compatible SQL Server instance,
- Visual Studio Code,
- the Microsoft SQL Server (`mssql`) extension, and
- the SQL Database Projects extension.

For command-line project builds, install a supported .NET SDK. For command-line database setup, install `sqlcmd` or use the copy bundled in the SQL Server container image.

### 3. Create the database

Connect to the server and create `BikeStores` only if it does not already exist:

```sql
IF DB_ID(N'BikeStores') IS NULL
BEGIN
    CREATE DATABASE BikeStores;
END;
GO
```

### 4. Create the objects and load the data

Connect explicitly to `BikeStores`, then run these scripts in order:

1. `source-data/BikeStores Sample Database - create objects.sql`
2. `source-data/BikeStores Sample Database - load data.sql`
3. `source-data/BikeStores Sample Database - Create HR schema and tables.sql`

The scripts do not create or select the database, so confirm the connection context before running them:

```sql
SELECT DB_NAME() AS CurrentDatabase;
GO
```

The expected value is `BikeStores`. The third script creates the `hr` schema when needed, then drops and recreates `hr.candidates` and `hr.employees` with four rows each. It is safe for a clean reproducible setup, but rerunning it discards changes made to those two demonstration tables.

Do not run `BikeStores Sample Database - drop all objects.sql` during normal setup. It is destructive and is intended only for an explicit reset.

### 5. Validate the sample database

```sql
SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_SCHEMA IN (N'hr', N'production', N'sales')
ORDER BY
    TABLE_SCHEMA,
    TABLE_NAME;
GO

SELECT COUNT(*) AS ProductCount
FROM production.products;
GO

SELECT COUNT(*) AS OrderCount
FROM sales.orders;
GO

SELECT COUNT(*) AS CandidateCount
FROM hr.candidates;
GO

SELECT COUNT(*) AS EmployeeCount
FROM hr.employees;
GO
```

The expected setup contains nine upstream BikeStores base tables plus the two HR demonstration tables. The product and order counts should be greater than zero; the deterministic HR script creates four candidates and four employees.

### 6. Run the analysis queries

Open a file under `database/queries/`, connect it to `BikeStores`, and run either individual statements or the complete file. Verify the active database whenever the connection is uncertain:

```sql
SELECT DB_NAME() AS CurrentDatabase;
GO
```

### 7. Build the SQL project

From the project root:

```bash
dotnet build "Bicycle Shop Analysis.sqlproj"
```

A successful build validates the SQL project and creates build output under `bin/` and `obj/`. Those generated directories should not be committed.

## Safety Notes

- Do not run the drop-all-objects script unless a database reset is intentional.
- Do not rerun the HR setup script if changes in `hr.candidates` or `hr.employees` must be preserved; it drops and recreates both tables.
- Do not commit passwords, connection strings containing secrets, backups, or generated database files.
- Always pass or verify the `BikeStores` database context before running setup or analysis scripts.
- Building the SQL project is separate from publishing it to a database.

## Attribution

The BikeStores sample database and original setup scripts are provided by [SQLServerTutorial.net](https://www.sqlservertutorial.net/getting-started/sql-server-sample-database/). The analytical queries, project organization, documentation, and conclusions in this repository are my own unless otherwise noted.
