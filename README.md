# Bicycle Shop Analysis

A SQL Server portfolio project built around the **BikeStores** sample database. The project is designed to demonstrate practical SQL development, database project organization, analytical querying, and reproducible setup using Microsoft SQL Server and Visual Studio Code.

This repository is intended to be useful to both technical and non-technical reviewers. You can inspect the work directly on GitHub without installing anything, or reproduce the database locally and run the queries yourself.

## Project Status

**Current phase:** Environment and database setup complete. Analysis work is in progress.

The repository currently includes:

- A SQL Database Project for the BikeStores schema
- Source scripts used to create and populate the sample database
- A local reproduction workflow
- Space for analytical SQL, documentation, and findings as the project develops

## Project Goals

This project is being used to strengthen and demonstrate SQL skills through a complete development workflow rather than isolated practice problems.

The project will focus on:

- Relational database structure
- SQL querying
- Joins
- Aggregations
- Common table expressions
- Window functions
- Views
- Stored procedures
- Functions
- Data validation
- Query organization
- Performance analysis and indexing
- Business-oriented analysis
- Source control with Git
- SQL Database Projects and DACPAC-based development

## Technology

- **Microsoft SQL Server 2025 Express**
- **Visual Studio Code**
- **SQL Server (mssql) extension for VS Code**
- **Microsoft SQL Database Projects**
- **Git / GitHub**
- **T-SQL**

My development instance is self-hosted on an Ubuntu Server VM in my homelab using Docker. A reviewer does **not** need to reproduce that infrastructure. The instructions below use a normal local SQL Server Express installation.

## Data Source

The project uses the **BikeStores** SQL Server sample database published by SQLServerTutorial.net:

https://www.sqlservertutorial.net/getting-started/sql-server-sample-database/

The sample database contains two primary schemas:

- `production`
- `sales`

The original source scripts are retained in the `source-data` directory so the database can be recreated locally.

## Repository Structure

The repository will continue to evolve as the analysis progresses, but the major components are organized as follows:

```text
Bicycle Shop Analysis/
├── Bicycle Shop Analysis.sqlproj
├── source-data/
│   ├── BikeStores Sample Database - create objects.sql
│   ├── BikeStores Sample Database - load data.sql
│   └── BikeStores Sample Database - drop all objects.sql
├── analysis/
├── docs/
└── README.md
```

### `Bicycle Shop Analysis.sqlproj`

The SQL Database Project file defines the source-controlled database project.

The Database Project represents the database schema separately from the live SQL Server database. It can be used to inspect, build, compare, and eventually publish schema changes.

### `source-data/`

Contains the original BikeStores scripts used to create and populate the local database.

### `analysis/`

Contains the SQL written as part of my own analysis.

Each analysis file is intended to focus on a business question, SQL concept, or analytical technique.

### `docs/`

Contains supporting documentation, diagrams, development notes, screenshots, and other project material.

---

# Reviewing the Project Without Installing Anything

You do not need SQL Server to inspect this project.

You can review the repository directly on GitHub and inspect:

- SQL source files
- Database object definitions
- Analysis queries
- Documentation
- Commit history
- README updates
- Development progress

You can also open the repository using VS Code for the Web:

https://vscode.dev/github/Znovak2/sql-portfolio

This is useful for browsing the project in a VS Code-style interface without cloning the repository.

---

# Reproducing the Project Locally

The steps below recreate the `BikeStores` database on a local machine and allow you to execute the project's SQL.

## 1. Install Microsoft SQL Server 2025 Express

Download SQL Server from Microsoft:

https://www.microsoft.com/en-us/sql-server/sql-server-downloads

Install **SQL Server 2025 Express**.

Express is sufficient for reproducing this project.

During installation, note:

- Your SQL Server instance name
- Your configured authentication method
- Any SQL login credentials you create

A common SQL Server Express instance name is:

```text
localhost\SQLEXPRESS
```

Your installation may use a different instance name.

## 2. Install Visual Studio Code

Download and install Visual Studio Code:

https://code.visualstudio.com/download

## 3. Install the SQL Server Extension

Open Visual Studio Code.

Open the Extensions view and install:

**SQL Server (mssql)** by Microsoft

Extension page:

https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql

The Microsoft SQL Database Projects functionality is available through the current Microsoft SQL tooling for VS Code.

If VS Code prompts you to install additional prerequisites, such as the .NET SDK for SQL Database Project build functionality, follow the provided installation prompt.

## 4. Download the Repository

### Option A: Download ZIP

This is the easiest method if you do not normally use Git.

1. Open the repository on GitHub.
2. Click **Code**.
3. Select **Download ZIP**.
4. Extract the ZIP file to a local directory.
5. Open that directory in Visual Studio Code.

### Option B: Clone with Git

If Git is installed:

```bash
git clone https://github.com/Znovak2/sql-portfolio.git
```

Then open the cloned directory in Visual Studio Code.

## 5. Open the SQL Database Project

In Visual Studio Code:

1. Open the **Database Projects** view from the Activity Bar.
2. Choose the option to open an existing project.
3. Navigate to the local repository.
4. Select:

```text
Bicycle Shop Analysis.sqlproj
```

The project should now appear in the Database Projects panel.

This view represents the source-controlled database schema. It is separate from the running SQL Server instance.

## 6. Connect to SQL Server

Open the **SQL Server** view in Visual Studio Code.

Create a new SQL Server connection.

For a typical local SQL Server Express installation, the server may be:

```text
localhost\SQLEXPRESS
```

Use the authentication method configured during your SQL Server installation.

For the initial connection, connect to the `master` database.

## 7. Create the BikeStores Database

Open a new SQL query and run:

```sql
IF DB_ID(N'BikeStores') IS NULL
BEGIN
    CREATE DATABASE BikeStores;
END;
GO
```

Verify that the database exists:

```sql
SELECT name
FROM sys.databases
ORDER BY name;
GO
```

You should see:

```text
BikeStores
```

in the results.

## 8. Connect to BikeStores

Change the active database for the SQL connection to:

```text
BikeStores
```

Before running any setup scripts, verify the current database:

```sql
SELECT DB_NAME() AS CurrentDatabase;
GO
```

Expected result:

```text
BikeStores
```

This verification is important because running the setup scripts against the wrong database will create the objects in the wrong location.

## 9. Create the BikeStores Database Objects

Open:

```text
source-data/BikeStores Sample Database - create objects.sql
```

Confirm that the active connection is using the `BikeStores` database.

Run the entire script.

This creates the BikeStores schemas, tables, keys, relationships, and supporting database objects.

## 10. Load the Sample Data

Open:

```text
source-data/BikeStores Sample Database - load data.sql
```

Confirm again that the active connection is using `BikeStores`.

Run the entire script.

This populates the BikeStores tables with the sample data used by the project.

## 11. Verify the Database

Run:

```sql
SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
ORDER BY
    TABLE_SCHEMA,
    TABLE_NAME;
GO
```

You should see tables under the `production` and `sales` schemas.

To confirm that the database contains data:

```sql
SELECT TOP (10) *
FROM production.products;
GO
```

You can also inspect the number of orders:

```sql
SELECT COUNT(*) AS OrderCount
FROM sales.orders;
GO
```

If these queries return results, the local database is ready.

---

# Using the Database Project

The **Database Projects** view and the **SQL Server** view serve different purposes.

## SQL Server View

The SQL Server view connects to the live database.

Use it to:

- Browse the running `BikeStores` database
- Execute queries
- Inspect data
- Review live database objects
- Test analysis

## Database Projects View

The Database Projects view represents the database schema as source code.

Use it to:

- Inspect database object definitions
- Track schema changes in Git
- Build the database project
- Compare project schema against a database
- Publish schema changes
- Produce a DACPAC

Building the `.sqlproj` validates and compiles the project. Building the project by itself does not modify the live `BikeStores` database.

---

# Running the Analysis

Analytical work is stored in the `analysis` directory.

To run an analysis:

1. Open the desired `.sql` file.
2. Confirm that the active SQL connection is using `BikeStores`.
3. Execute the query.
4. Review the results in VS Code.

Before executing a query, you can always verify the active database with:

```sql
SELECT DB_NAME() AS CurrentDatabase;
GO
```

As the project develops, each analysis will document:

- The business question
- The SQL approach
- The result
- The interpretation
- Relevant SQL concepts demonstrated

---

# Analysis Areas

The project is expected to explore areas such as:

- Sales performance
- Product performance
- Store performance
- Customer behavior
- Staff performance
- Inventory
- Brands and categories
- Time-based sales trends
- Order composition
- Revenue concentration
- Operational patterns

Specific analyses and findings will be added as the project progresses.

---

# Skills Demonstrated

This repository is intended to demonstrate both SQL knowledge and development practices.

Areas demonstrated or planned include:

- T-SQL
- Relational data modeling
- Multi-table joins
- Aggregation
- Subqueries
- Common table expressions
- Window functions
- Views
- Stored procedures
- Functions
- Indexes
- Query performance
- Data validation
- Schema management
- SQL Database Projects
- Git-based source control
- Reproducible development environments
- Technical documentation
- Translating data into business conclusions

---

# Cleaning Up After Review

No cleanup is required.

You can simply close Visual Studio Code and leave the `BikeStores` database installed for future use.

If you want to completely remove the local BikeStores database, connect to SQL Server and run:

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

This deletes the local `BikeStores` database.

It does **not** uninstall:

- SQL Server
- Visual Studio Code
- The VS Code extensions
- The downloaded repository

You can delete the local repository directory separately if it is no longer needed.

---

# Troubleshooting

## The BikeStores tables do not appear

Verify that the object creation script was executed while connected to `BikeStores`:

```sql
SELECT DB_NAME() AS CurrentDatabase;
GO
```

If the result is not `BikeStores`, reconnect to the correct database and run the create-objects script again.

## The tables exist but contain no data

Run:

```sql
SELECT COUNT(*) AS ProductCount
FROM production.products;
GO
```

If the table exists but contains no rows, rerun:

```text
source-data/BikeStores Sample Database - load data.sql
```

against the `BikeStores` database.

## BikeStores does not appear in the database list

Run:

```sql
SELECT name
FROM sys.databases
ORDER BY name;
GO
```

If `BikeStores` is missing, create it using the database creation step above and refresh the SQL Server view.

## The SQL Database Project builds but the live database does not change

This is expected.

A Database Project **build** validates and compiles the schema into a deployable artifact. It does not automatically publish those changes to the live SQL Server database.

---

# Development Notes

This project is being developed incrementally.

The environment setup, project structure, obstacles, decisions, and lessons learned are documented separately in development logs so that the repository shows not only the final SQL, but also the development process used to reach it.

---

# Attribution

The BikeStores sample database and original sample data scripts are provided by:

**SQLServerTutorial.net**

https://www.sqlservertutorial.net/getting-started/sql-server-sample-database/

The analytical SQL, project organization, documentation, and conclusions in this repository are my own work unless otherwise noted.
