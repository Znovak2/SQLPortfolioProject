-- INNER JOIN produces a data set that includes rows from the left table, and matching rows from the right table.
-- Q: What candidates did we hire through the candidate process?
SELECT
    c.id candidate_id, -- rename the candidates table id column for clarity
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM
    hr.candidates c
    INNER JOIN hr.employees e
        ON e.fullname = c.fullname; -- joining the candidates table ON the employee table answers the question more clearly than the converse.

-- LEFT JOIN selects data starting from the left table and matching rows in the right table.
-- LEFT JOIN returns all rows from the left table, while only the applicable rows in the right table.
-- If a row is only in the left table, the right table values are populated with NULL.
-- Also known as 'Left Outer Join'.
-- Q: What is our full list of candidates, while including employee data where applicable.
SELECT
    c.id candidate_id, -- rename the candidates table id column for clarity
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM
    hr.candidates c
    LEFT JOIN hr.employees e
        ON e.fullname = c.fullname;

-- LEFT ANTI JOIN pulls rows that are only in the left table, but not in the right table.
-- MSSQL does not have a literal 'LEFT ANTI JOIN' keyword, so it is implemented with the WHERE IS NULL approach.
-- Q: Who are the candidates we did not move forward with?
SELECT
    c.id candidate_id, -- rename the candidates table id column for clarity
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM
    hr.candidates c
    LEFT JOIN hr.employees e
        ON e.fullname = c.fullname
WHERE
    e.id IS NULL;

-- RIGHT JOIN (A.K.A. RIGHT OUTER JOIN) selects data starting from the right table.
-- RIGHT OUTER JOIN returns a full set of rows from the right table, while only the applicable rows from the left table.
-- Q: What is a full set of our employees which also reflects their candidate information from hiring.
SELECT
    c.id candidate_id, -- rename the candidates table id column for clarity
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM
    hr.candidates c
    RIGHT JOIN hr.employees e
        ON e.fullname = c.fullname;

-- RIGHT ANTI JOIN will return rows which are only in the right table.
-- Q: Which of our employees did not go through the traditional candidate hiring process?
SELECT
    c.id candidate_id, -- rename the candidates table id column for clarity
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM
    hr.candidates c
    RIGHT JOIN hr.employees e
        ON e.fullname = c.fullname
WHERE
    c.id IS NULL;

-- FULL JOIN (A.K.A. FULL OUTER JOIN) returns a result set that contains all rows from both left and right tables, while matching applicable rows.
-- In the event of no matching rows, the missing side will have NULL values.
-- Q: What is a refined result set to show our employee's and candidate's full HR profile.
SELECT
    c.id candidate_id, -- rename the candidates table id column for clarity
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM
    hr.candidates c
    FULL JOIN hr.employees e
        ON e.fullname = c.fullname;

-- FULL ANTI JOIN will return rows which are not in the other table.
-- Q: What is a result set where we can examine only Candidates or Employees which ARE NOT in the other.
SELECT
    c.id candidate_id, -- rename the candidates table id column for clarity
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM
    hr.candidates c
    FULL JOIN hr.employees e
        ON e.fullname = c.fullname
WHERE
    c.id IS NULL OR
    e.id IS NULL;
