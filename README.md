# Bicycle Shop Analysis

A SQL Server portfolio project using the **BikeStores** sample database to document and demonstrate my progression from core T-SQL concepts through database development, analytical querying, performance work, and business-oriented analysis.

The repository is designed so that a reviewer can either:

1. inspect the SQL and project history directly on GitHub,
2. reproduce the project locally with SQL Server and Visual Studio Code, or
3. give the included [`AGENTS_README.md`](./AGENTS_README.md) to an agentic coding assistant and have it prepare the project for inspection.

> **Using a coding agent?**  
> See [`AGENTS_README.md`](./AGENTS_README.md). It contains machine-oriented setup instructions, validation checks, safety constraints, and a ready-to-copy agent prompt.

## Project Status

**Current phase:** Core SQL learning and analysis.

The database environment and source data are established. Current work is focused on writing, organizing, and documenting SQL queries while progressively adding more advanced SQL concepts.

## What This Project Is Intended to Demonstrate

The goal is not only to produce a collection of SQL queries. The repository is intended to show how I approach a SQL project as a complete development workflow.

Areas covered or planned include:

- SELECT statements and filtering
- Sorting and grouping
- Joins
- Aggregations
- Subqueries
- Common table expressions
- Window functions
- Views
- Stored procedures
- Functions
- Data validation
- Relational database structure
- Query organization
- Indexing and query performance
- SQL Database Projects
- Git-based source control
- Reproducible project setup
- Business-oriented analysis and interpretation

## Technology

- **Microsoft SQL Server 2025 Express**
- **T-SQL**
- **Visual Studio Code**
- **SQL Server (mssql) extension for VS Code**
- **Microsoft SQL Database Projects**
- **Microsoft.Build.Sql**
- **Git / GitHub**

My development SQL Server is self-hosted on an Ubuntu Server VM in my homelab using Docker. Reviewers do **not** need to reproduce my homelab infrastructure. The manual setup below uses a normal local SQL Server installation.

## Data Source

This project uses the **BikeStores** sample database provided by SQLServerTutorial.net:

https://www.sqlservertutorial.net/getting-started/sql-server-sample-database/

The original sample scripts are retained under [`source-data/`](./source-data/) so the database can be recreated.

The sample database uses two primary schemas:

- `production`
- `sales`

## Current Repository Structure

```text
sql-portfolio/
├── .vscode/
├── Bicycle Shop Analysis.sqlproj
├── database/
│   └── queries/
│       ├── ORDER_BY.sql
│       └── SELECT.sql
├── source-data/
│   ├── BikeStores Sample Database - create objects.sql
│   ├── BikeStores Sample Database - drop all objects.sql
│   └── BikeStores Sample Database - load data.sql
├── AGENTS_README.md
└── README.md
```

### `Bicycle Shop Analysis.sqlproj`

The SQL Database Project definition.

It represents the source-controlled database project separately from the live `BikeStores` database. The project can be built, inspected, compared, and later used as part of a schema deployment workflow.

### `database/queries/`

Contains my SQL learning and analysis work.

Current query files include:

- [`SELECT.sql`](./database/queries/SELECT.sql)
- [`ORDER_BY.sql`](./database/queries/ORDER_BY.sql)

This directory will continue to grow as additional SQL concepts and business questions are covered.

### `source-data/`

Contains the original scripts required to recreate the BikeStores sample database.

These files are source data and setup material. They are not presented as my original analytical work.

---

# Review the Project Without Installing Anything

No local SQL Server is required to inspect the repository.

A reviewer can browse:

- SQL queries
- SQL comments and reasoning
- Database project configuration
- Source data scripts
- Git history
- README changes
- Project progression over time

The repository can also be opened in VS Code for the Web:

https://vscode.dev/github/Znovak2/sql-portfolio

This provides a VS Code-style browsing experience without requiring a local clone.

---

# AI-Assisted Setup

If you would like an agentic coding assistant to prepare the project for you, or you are an agent reading this repository, use:

[`AGENTS_README.md`](./AGENTS_README.md)

That file includes:

- the required end state,
- environment detection instructions,
- an automated Docker-based setup path,
- database creation and loading instructions,
- project build instructions,
- verification queries,
- safety rules,
- cleanup guidance, and
- a complete prompt that can be copied into a coding agent.

---

# Manual Local Setup

The following instructions are intended for someone who wants to reproduce the database and execute the queries locally.

## 1. Install Microsoft SQL Server 2025 Express

Download SQL Server from Microsoft:

https://www.microsoft.com/en-us/sql-server/sql-server-downloads

Install **SQL Server 2025 Express**.

During installation, note:

- the SQL Server instance name,
- the authentication method you configured, and
- any SQL login credentials you created.

A common SQL Server Express instance name is:

```text
localhost\SQLEXPRESS
```

Your instance name may be different.

## 2. Install Visual Studio Code

Download Visual Studio Code:

https://code.visualstudio.com/download

## 3. Install the Microsoft SQL Server Extension

In Visual Studio Code, open **Extensions** and install:

**SQL Server (mssql)** by Microsoft

Extension page:

https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql

The Microsoft SQL tooling provides SQL Server connections, query execution, and Database Projects functionality.

If Visual Studio Code prompts for an additional prerequisite such as the .NET SDK for SQL Database Project build functionality, follow the installation prompt.

## 4. Download the Repository

### Option A: Download ZIP

This is the simplest option if you do not normally use Git.

1. Open the repository on GitHub.
2. Click **Code**.
3. Select **Download ZIP**.
4. Extract the ZIP file.
5. Open the extracted repository folder in Visual Studio Code.

### Option B: Clone with Git

```bash
git clone https://github.com/Znovak2/sql-portfolio.git
cd sql-portfolio
```

Then open the repository in Visual Studio Code.

## 5. Open the SQL Database Project

In Visual Studio Code:

1. Open the **Database Projects** view from the Activity Bar.
2. Choose the option to open an existing project.
3. Navigate to the repository root.
4. Select:

```text
Bicycle Shop Analysis.sqlproj
```

The project should now appear in the Database Projects panel.

## 6. Connect to SQL Server

Open the **SQL Server** view in Visual Studio Code and create a connection to your local SQL Server instance.

For a typical SQL Server Express installation, the server may be:

```text
localhost\SQLEXPRESS
```

Use the authentication method configured during SQL Server installation.

For the initial connection, connect to the `master` database.

## 7. Create the `BikeStores` Database

Open a new query and run:

```sql
IF DB_ID(N'BikeStores') IS NULL
BEGIN
    CREATE DATABASE BikeStores;
END;
GO
```

Verify:

```sql
SELECT name
FROM sys.databases
ORDER BY name;
GO
```

`BikeStores` should appear in the results.

## 8. Switch the Connection to `BikeStores`

Before running any setup scripts, verify the active database:

```sql
SELECT DB_NAME() AS CurrentDatabase;
GO
```

Expected result:

```text
BikeStores
```

If the result is not `BikeStores`, change the active database before continuing.

## 9. Create the BikeStores Database Objects

Open:

```text
source-data/BikeStores Sample Database - create objects.sql
```

Confirm that the active connection is using `BikeStores`.

Run the entire script.

This creates the `production` and `sales` schemas and the sample database tables and relationships.

## 10. Load the BikeStores Sample Data

Open:

```text
source-data/BikeStores Sample Database - load data.sql
```

Confirm again that the active connection is using `BikeStores`.

Run the entire script.

This populates the sample tables with the data used by the project.

## 11. Verify the Database

Run:

```sql
SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY
    TABLE_SCHEMA,
    TABLE_NAME;
GO
```

The BikeStores sample database should contain tables in the `production` and `sales` schemas.

Verify that data is present:

```sql
SELECT TOP (10) *
FROM production.products;
GO
```

and:

```sql
SELECT COUNT(*) AS OrderCount
FROM sales.orders;
GO
```

If these queries return data, the database is ready.

---

# Running My SQL Work

The current SQL work is under:

```text
database/queries/
```

For example:

```text
database/queries/SELECT.sql
database/queries/ORDER_BY.sql
```

To inspect a query:

1. Open the `.sql` file in Visual Studio Code.
2. Confirm that the active SQL connection is using `BikeStores`.
3. Read the comments describing the purpose of each example.
4. Run individual statements or the complete file.
5. Review the results.

A quick database-context check can be run at any time:

```sql
SELECT DB_NAME() AS CurrentDatabase;
GO
```

---

# SQL Server View vs. Database Projects View

These two Visual Studio Code views serve different purposes.

## SQL Server View

The SQL Server view connects to the **live SQL Server instance**.

Use it to:

- browse `BikeStores`,
- inspect live objects,
- execute queries,
- inspect table data, and
- test SQL.

## Database Projects View

The Database Projects view represents the **source-controlled database project**.

Use it to:

- inspect database object definitions,
- track schema changes,
- build the `.sqlproj`,
- validate project structure,
- compare project schema with a live database, and
- produce deployment artifacts such as a DACPAC.

Building the project does **not** automatically change the live `BikeStores` database.

---

# Building the SQL Database Project

If the .NET SDK is available, the project can be built from the repository root:

```bash
dotnet build "Bicycle Shop Analysis.sqlproj"
```

The project currently uses `Microsoft.Build.Sql` and targets the SQL Server 2025 schema provider.

A successful build validates the SQL Database Project and produces build artifacts. It does not populate the sample data.

---

# Resetting the Sample Objects

The repository contains:

```text
source-data/BikeStores Sample Database - drop all objects.sql
```

This script removes the BikeStores sample objects.

Use it only if you intentionally want to reset the database before recreating the objects and loading the data again.

For normal review, no reset is required.

---

# Removing the Local Database

No cleanup is required after reviewing the project.

If you intentionally want to delete the local `BikeStores` database:

```sql
USE master;
GO

ALTER DATABASE BikeStores
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE BikeStores;
GO
```

This removes the database only. It does not uninstall SQL Server, Visual Studio Code, or the repository.

---

# Troubleshooting

## `BikeStores` does not appear

Check the available databases:

```sql
SELECT name
FROM sys.databases
ORDER BY name;
GO
```

If `BikeStores` is missing, create it using the setup step above and refresh the SQL Server view.

## The BikeStores tables do not appear

Verify the current database:

```sql
SELECT DB_NAME() AS CurrentDatabase;
GO
```

If it is not `BikeStores`, switch to the correct database and rerun:

```text
source-data/BikeStores Sample Database - create objects.sql
```

## Tables exist but contain no sample data

Check:

```sql
SELECT COUNT(*) AS ProductCount
FROM production.products;
GO
```

If the tables exist but contain no rows, rerun:

```text
source-data/BikeStores Sample Database - load data.sql
```

against `BikeStores`.

## The Database Project builds but the live database does not change

This is expected.

A build validates and compiles the Database Project. Publishing or executing SQL against a live connection is a separate operation.

---

# Development Approach

This repository is intentionally being developed incrementally.

Rather than presenting only a finished set of queries, the Git history is intended to show the progression of the project, including:

- concepts being practiced,
- changes in query complexity,
- project organization,
- corrections and refinements, and
- movement from syntax exercises toward business-oriented analysis.

---

# Attribution

The BikeStores sample database and the original sample database scripts are provided by:

**SQLServerTutorial.net**

https://www.sqlservertutorial.net/getting-started/sql-server-sample-database/

The SQL learning work, analytical queries, project organization, documentation, and conclusions in this repository are my own unless otherwise noted.
