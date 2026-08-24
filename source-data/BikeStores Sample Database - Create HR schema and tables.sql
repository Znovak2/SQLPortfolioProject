-- Enhanced with AI Assistance for deterministic source data seeding.
-- Rerunnable setup script
-- Drops and recreates the demo tables each time.

-- Create HR schema only if it does not already exist
IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'hr'
)
BEGIN
    EXEC('CREATE SCHEMA hr');
END;

GO

-- Drop tables if they already exist
DROP TABLE IF EXISTS hr.candidates;
DROP TABLE IF EXISTS hr.employees;

-- Recreate tables
CREATE TABLE hr.candidates (
    id INT PRIMARY KEY IDENTITY,
    fullname VARCHAR(100) NOT NULL
);

CREATE TABLE hr.employees (
    id INT PRIMARY KEY IDENTITY,
    fullname VARCHAR(100) NOT NULL
);

-- Populate candidates
INSERT INTO hr.candidates (fullname)
VALUES
    ('John Doe'),
    ('Lily Bush'),
    ('Peter Drucker'),
    ('Jane Doe');

-- Populate employees
INSERT INTO hr.employees (fullname)
VALUES
    ('John Doe'),
    ('Jane Doe'),
    ('Michael Scott'),
    ('Jack Sparrow');
