# Bicycle Shop Analysis

A SQL Server portfolio project built on the BikeStores sample database. It contains focused T-SQL examples that progress from foundational querying into joins, grouping, subqueries, and more advanced relational patterns. The repository also demonstrates a complete database lifecycle: define the schema, load deterministic sample data, validate the queries, and remove the objects only when an intentional reset is required.

You can review the project in two ways:

1. Browse the SQL files and Git history without running a database.
2. Recreate `BikeStores` locally and execute the examples against live sample data.

## Project Status

The basic collection currently covers selection, filtering, sorting, pagination, grouping, aggregation, `HAVING`, subqueries, aliases, null handling, and the main join types. The advanced collection currently includes a completed self-join exploration; `ADV_CROSS_JOIN.sql` is a clearly marked placeholder for planned work.

Future showcase work includes completing the advanced cross-join example, common table expressions, window functions, views, stored procedures, functions, data validation, indexing, and query-performance techniques.

## Technology

- Microsoft SQL Server 2025 Express
- T-SQL
- Visual Studio Code
- SQL Server (`mssql`) extension for Visual Studio Code
- SQL Database Projects extension for Visual Studio Code
- Microsoft.Build.Sql 2.2.0
- Git and GitHub

The SQL project targets the SQL Server 2025 (`Sql170`) schema provider. My development instance runs in Docker on an Ubuntu Server VM, but any compatible SQL Server instance can be used.

## Data Source and Schemas

This project adapts the [BikeStores sample database](https://www.sqlservertutorial.net/getting-started/sql-server-sample-database/) from SQLServerTutorial.net. The checked-in schema and seed scripts retain the upstream attribution and extend the sample with deterministic `hr` and `pm` data used by the join demonstrations.

The live database contains four schemas:

- `production` and `sales` contain the BikeStores tables.
- `hr` contains candidate and employee data for join examples.
- `pm` contains project and member data for cross-join examples.

## Repository Structure

```text
bicycle-shop-analysis/
├── .vscode/
│   ├── extensions.json
│   ├── settings.json
│   └── tasks.json
├── database/
│   ├── queries/
│   │   ├── basic/       # Focused foundational examples
│   │   └── advanced/    # More involved examples and planned work
│   ├── schema/          # Creates schemas, tables, keys, and constraints
│   ├── seed/            # Loads BikeStores and demonstration data
│   └── utilities/       # Destructive reset script
├── AGENTS_README.md     # Detailed setup and safety runbook
├── Bicycle Shop Analysis.sqlproj
└── README.md
```

## Review the SQL

The repository can be browsed on GitHub or through [VS Code for the Web](https://vscode.dev/github/Znovak2/sql-portfolio). Start with these representative files:

- [`SELECT.sql`](./database/queries/basic/SELECT.sql) builds from projection and filtering through grouping and `HAVING`.
- [`GROUP_BY.sql`](./database/queries/basic/GROUP_BY.sql) develops grouped reporting patterns and aggregate calculations.
- [`SUBQUERY.sql`](./database/queries/basic/SUBQUERY.sql) demonstrates list membership, nested filters, and multiple levels of nesting.
- [`JOIN.sql`](./database/queries/basic/JOIN.sql) compares inner, outer, and anti-join patterns against deterministic HR data.
- [`ADV_SELF_JOIN.sql`](./database/queries/advanced/ADV_SELF_JOIN.sql) uses self joins for reporting hierarchies and comparing customers within a city.

Browse [`database/queries/basic/`](./database/queries/basic/) for the completed concept examples and [`database/queries/advanced/`](./database/queries/advanced/) for advanced or explicitly planned work. Executing the files is optional and requires a populated `BikeStores` database.

## Local Setup

### 1. Clone and enter the project

```bash
git clone https://github.com/Znovak2/sql-portfolio.git
cd sql-portfolio
```

All commands below assume the repository root is the current directory.

### 2. Install the prerequisites

Make available:

- a compatible SQL Server instance;
- Visual Studio Code with the recommended `mssql` and SQL Database Projects extensions, if using the editor workflow;
- a supported .NET SDK for command-line project builds; and
- `sqlcmd` for command-line database setup and validation.

The detailed [`AGENTS_README.md`](./AGENTS_README.md) runbook also documents an optional Docker path.

### 3. Create a clean database

Connect to SQL Server and create `BikeStores` only if it does not already exist:

```sql
IF DB_ID(N'BikeStores') IS NULL
BEGIN
    CREATE DATABASE BikeStores;
END;
GO
```

Before continuing, inspect an existing `BikeStores` database. The schema script creates tables without dropping existing ones, and the seed script inserts fixed identifiers; do not run either over a partial or populated copy.

### 4. Create the objects and load the data

Run these scripts in order against `BikeStores`:

1. `database/schema/BikeStores Sample Database - create objects.sql`
2. `database/seed/BikeStores Sample Database - load data.sql`

The first script creates the `production`, `sales`, `hr`, and `pm` schemas and their 13 tables. The second loads the BikeStores sample rows plus deterministic HR and project-management fixtures.

Do not run `database/utilities/BikeStores Sample Database - drop all objects.sql` during normal setup. It removes all four project schemas and their objects and is intended only for an explicit reset.

### 5. Validate the database

```sql
SELECT DB_NAME() AS CurrentDatabase;
GO

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_SCHEMA IN (N'hr', N'pm', N'production', N'sales')
ORDER BY
    TABLE_SCHEMA,
    TABLE_NAME;
GO

SELECT COUNT(*) AS ProductCount FROM production.products;
SELECT COUNT(*) AS OrderCount FROM sales.orders;
SELECT COUNT(*) AS CandidateCount FROM hr.candidates;
SELECT COUNT(*) AS EmployeeCount FROM hr.employees;
SELECT COUNT(*) AS ProjectCount FROM pm.projects;
SELECT COUNT(*) AS MemberCount FROM pm.members;
GO
```

The expected result is `BikeStores`, 13 base tables, nonzero product and order counts, four candidates, four employees, three projects, and four members.

### 6. Run the query examples

Open a completed file under `database/queries/basic/` or `database/queries/advanced/`, connect it to `BikeStores`, and run individual statements or the complete file. `ADV_CROSS_JOIN.sql` is planned work and contains no executable query yet.

### 7. Build the SQL project

```bash
dotnet build "Bicycle Shop Analysis.sqlproj"
```

A successful build validates the SQL project and creates a DACPAC under `bin/`. It does not create, populate, publish, or otherwise change the live database. Generated `bin/` and `obj/` directories should not be committed.

## Safety Notes

- Inspect an existing `BikeStores` database before loading data; the checked-in lifecycle scripts target a clean database.
- Never run the drop-all-objects utility unless a reset is intentional.
- Do not commit passwords, secret-bearing connection strings, backups, or generated database files.
- Pass or verify the `BikeStores` database context before running setup or query scripts.
- Treat building, loading sample data, publishing a DACPAC, and dropping objects as separate operations.

For command-line, Docker, troubleshooting, and complete validation procedures, see [`AGENTS_README.md`](./AGENTS_README.md).

## Attribution

The BikeStores sample database and original data are provided by [SQLServerTutorial.net](https://www.sqlservertutorial.net/getting-started/sql-server-sample-database/). The analytical queries, project-specific fixtures and extensions, project organization, documentation, and conclusions are my own unless otherwise noted.
