# Bicycle Shop Analysis

A SQL Server portfolio project built on the BikeStores sample database. It contains focused T-SQL examples that progress from foundational querying into joins, grouping, subqueries, and more advanced relational patterns. The repository also demonstrates a complete database lifecycle: define the schema, load deterministic sample data, validate the queries, and remove the objects only when an intentional reset is required.

You can review the project in two ways:

1. Browse the SQL files and Git history without running a database.
2. Recreate `BikeStores` locally and execute the examples against live sample data.

## Project Status

The basic collection currently covers selection, filtering, sorting, pagination, grouping, aggregation, `HAVING`, subqueries, aliases, null handling, joins, and the `ALL`, `ANY`, and `EXISTS` operators. The advanced collection includes completed correlated-subquery, self-join, and `CROSS APPLY` explorations. `ADV_CROSS_JOIN.sql` is a clearly marked placeholder for planned work.

Future showcase work includes completing the advanced cross-join example, common table expressions, window functions, views, stored procedures, additional functions, data validation, indexing, and query-performance techniques.

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

This project adapts the [BikeStores sample database](https://www.sqlservertutorial.net/getting-started/sql-server-sample-database/) from SQLServerTutorial.net. The checked-in schema and seed scripts retain the upstream attribution and extend the sample with deterministic `hr` and `pm` data for join demonstrations plus company-name and JSON fixtures for `CROSS APPLY` examples.

Project objects use four named schemas plus two helper tables in the executing user's default schema:

- `production` and `sales` contain the BikeStores tables.
- `hr` contains candidate and employee data for join examples.
- `pm` contains project and member data for the full-outer-join examples.
- `companies` and `product_json` provide deterministic string and JSON data for the `CROSS APPLY` examples. With the documented setup, these unqualified objects resolve to `dbo.companies` and `dbo.product_json`.

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
│   └── utilities/       # Destructive partial-cleanup script
├── AGENTS_README.md     # Detailed setup and safety runbook
├── Bicycle Shop Analysis.sqlproj
├── Definitions.md       # Short glossary of SQL concepts used in the project
└── README.md
```

## Review the SQL

The repository can be browsed on GitHub or through [VS Code for the Web](https://vscode.dev/github/Znovak2/sql-portfolio). Start with these representative files:

- [`SELECT.sql`](./database/queries/basic/SELECT.sql) builds from projection and filtering through grouping and `HAVING`.
- [`GROUP_BY.sql`](./database/queries/basic/GROUP_BY.sql) develops grouped reporting patterns and aggregate calculations.
- [`SUBQUERY.sql`](./database/queries/basic/SUBQUERY.sql) demonstrates list membership, nested filters, and multiple levels of nesting.
- [`EXISTS.sql`](./database/queries/basic/EXISTS.sql) contrasts `EXISTS` and `NOT EXISTS`, including null behavior.
- [`JOIN.sql`](./database/queries/basic/JOIN.sql) compares inner, outer, and anti-join patterns against deterministic HR data.
- [`ADV_CORR_SUBQUERY.sql`](./database/queries/advanced/ADV_CORR_SUBQUERY.sql) uses a correlated subquery to find each category's highest-priced products while retaining ties.
- [`ADV_CROSS_APPLY.sql`](./database/queries/advanced/ADV_CROSS_APPLY.sql) combines a table-valued function, a correlated subquery, JSON parsing, and incremental string cleanup. It creates or updates `GetTopProductsByCategory` when executed.
- [`ADV_SELF_JOIN.sql`](./database/queries/advanced/ADV_SELF_JOIN.sql) uses self joins for reporting hierarchies and comparing customers within a city.

Browse [`database/queries/basic/`](./database/queries/basic/) for the completed concept examples, [`database/queries/advanced/`](./database/queries/advanced/) for advanced or explicitly planned work, and [`Definitions.md`](./Definitions.md) for concise terminology notes. Executing the SQL files is optional and requires a populated `BikeStores` database.

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

The schema and `ADV_CROSS_APPLY.sql` currently use unqualified helper-object names. Run setup and the query examples as a database user whose default schema is `dbo`, or ensure those names resolve to the same schema throughout the workflow.

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

The first script creates the `production`, `sales`, `hr`, and `pm` schemas, 13 schema-qualified tables, and the `companies` and `product_json` helper tables in the executing user's default schema. The second loads the BikeStores sample rows plus deterministic HR, project-management, company-name, and JSON fixtures.

Do not run `database/utilities/BikeStores Sample Database - drop all objects.sql` during normal setup. It destructively removes the 13 tables under the four named project schemas, but it does not currently remove `companies`, `product_json`, or `GetTopProductsByCategory`; it is therefore a partial cleanup rather than a complete reset of the current project.

### 5. Validate the database

```sql
SELECT DB_NAME() AS CurrentDatabase;
GO

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_SCHEMA IN (N'dbo', N'hr', N'pm', N'production', N'sales')
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
SELECT COUNT(*) AS CompanyCount FROM dbo.companies;
SELECT COUNT(*) AS JsonProductCount FROM dbo.product_json;
GO
```

On a clean database using `dbo` as the default schema, the expected result is `BikeStores`, 15 base tables, nonzero product and order counts, four candidates, four employees, three projects, four members, three companies, and three JSON product rows.

### 6. Run the query examples

Open a completed file under `database/queries/basic/` or `database/queries/advanced/`, connect it to `BikeStores`, and run individual statements or the complete file. `ADV_CROSS_JOIN.sql` is the only planned file with no executable query yet.

In VS Code, the `BikeStores: Validate database` and `Queries: Run portfolio queries` tasks provide the same post-setup validation path for SQL-authenticated connections. They prompt for the server, user, and password; the query task runs every completed example and excludes `ADV_CROSS_JOIN.sql`.

Most query files are read-only demonstrations. `ADV_CROSS_APPLY.sql` is the exception: it creates or alters the `GetTopProductsByCategory` table-valued function before running its result-set examples.

### 7. Build the SQL project

```bash
dotnet build "Bicycle Shop Analysis.sqlproj"
```

A successful build validates the SQL project and creates a DACPAC under `bin/`. It does not create, populate, publish, or otherwise change the live database. Generated `bin/` and `obj/` directories should not be committed.

VS Code users can run the equivalent default build task, `SQL Project: Build`.

## Safety Notes

- Inspect an existing `BikeStores` database before loading data; the checked-in lifecycle scripts target a clean database.
- Never run the drop-all-objects utility unless destructive partial cleanup is intentional; it does not remove the current default-schema helper objects.
- Do not commit passwords, secret-bearing connection strings, backups, or generated database files.
- Pass or verify the `BikeStores` database context before running setup or query scripts.
- Treat building, loading sample data, publishing a DACPAC, and dropping objects as separate operations.

For command-line, Docker, troubleshooting, and complete validation procedures, see [`AGENTS_README.md`](./AGENTS_README.md).

## Attribution

The BikeStores sample database and original data are provided by [SQLServerTutorial.net](https://www.sqlservertutorial.net/getting-started/sql-server-sample-database/). The analytical queries, project-specific fixtures and extensions, project organization, documentation, and conclusions are my own unless otherwise noted.
