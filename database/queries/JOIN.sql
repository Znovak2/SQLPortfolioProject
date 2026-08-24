-- INNER JOIN produces a data set that includes rows from the left table, and matching rows from the right table.
-- What candidates did we hire?
SELECT
    c.id candidate_id, -- rename the candidates table id column for clarity
    c.fullname candidate_name,
    e.id employee_id,
    e.fullname employee_name
FROM
    hr.candidates c
    INNER JOIN hr.employees e
    ON e.fullname = c.fullname; -- joining the candidates table ON the employee table answers the question more clearly than the converse.
