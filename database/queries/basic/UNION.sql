-- UNION allows you to combine results of two SELECT statements into a single result set which includes all the rows that belong to the SELECT statements in the union.
-- Personally, I think this works similar to a Git merge - assuming no conflicts of course!

-- Demonstration of duplication and remove duplication:
-- Q: What is a combined list of staff and customers?
SELECT
    first_name,
    last_name
FROM
    sales.staffs
UNION
SELECT
    first_name,
    last_name
FROM
    sales.customers;
-- That returned 1,454 rows
SELECT
    first_name,
    last_name
FROM
    sales.staffs
UNION ALL
SELECT
    first_name,
    last_name
FROM
    sales.customers;
-- This query returned 1,455 rows 
