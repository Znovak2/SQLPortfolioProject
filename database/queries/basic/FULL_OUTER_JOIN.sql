-- FULL OUTER JOIN clause returns a results set that includes rows from both left and right tables.
-- When a table, left or right, does not have a corresponding matching row, it is filled with NULL regardless of direction.
-- Q: Generate a full report of projects and their assigned members.
SELECT m.name member, p.title project
FROM pm.members m
FULL OUTER JOIN pm.projects p
    ON p.id = m.project_id;

-- Q: Find members or projects that need assignment.
SELECT m.name member, p.title project
FROM pm.members m
FULL OUTER JOIN pm.projects p
    ON p.id = m.project_id
WHERE m.id IS NULL
    OR p.id IS NULL;
-- Result: This query identified Jack Daniel has no project, while the project Develop Mobile Sales Platform does not either. Jack Daniel will be assigned to Develop Mobile Sales Platform.

