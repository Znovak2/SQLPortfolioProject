-- Enhanced with AI Assistance for deterministic source data seeding.

-- Rerunnable setup script

-- Drops and recreates the demo tables each time.

-- Create PM schema only if it does not already exist

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'pm'
)
BEGIN
    EXEC('CREATE SCHEMA pm');
END;

GO

-- Drop tables if they already exist
-- Members must be dropped first because it has a foreign key dependency on projects

DROP TABLE IF EXISTS pm.members;
DROP TABLE IF EXISTS pm.projects;

-- Recreate tables

CREATE TABLE pm.projects (
    id INT PRIMARY KEY IDENTITY,
    title VARCHAR(255) NOT NULL
);

CREATE TABLE pm.members (
    id INT PRIMARY KEY IDENTITY,
    name VARCHAR(120) NOT NULL,
    project_id INT,
    FOREIGN KEY (project_id)
        REFERENCES pm.projects(id)
);

-- Populate projects

INSERT INTO pm.projects (title)
VALUES
    ('New CRM for Project Sales'),
    ('ERP Implementation'),
    ('Develop Mobile Sales Platform');

-- Populate members

INSERT INTO pm.members (name, project_id)
VALUES
    ('John Doe', 1),
    ('Lily Bush', 1),
    ('Jane Doe', 2),
    ('Jack Daniel', NULL);
