-- SELF JOIN allws a table to join itself.
-- It is useful for querying or retaining hierarchical data or to compare rows within the same table.
-- The use of Aliases is required.

-- Using self join to query hierarchical data
-- Q: Who reports to who accross the entire company?
SELECT
    e.first_name + ' ' + e.last_name employee,
    m.first_name + ' ' + m.last_name manager
FROM
    sales.staffs e
INNER JOIN sales.staffs m
    ON m.staff_id = e.manager_id
ORDER BY
    manager;
-- The above query returns the organization structure, but Fabiola who manages, but has no manager is not shown in the employee list.
-- This is because using INNER JOIN can remove data in which a column has a referenced value, but the referenced value does not have it's own row.
SELECT
    e.first_name + ' ' + e.last_name employee,
    m.first_name + ' ' + m.last_name manager
FROM
    sales.staffs e
LEFT JOIN sales.staffs m
    ON m.staff_id = e.manager_id
ORDER BY
    manager;
-- Result: Now we can see Fabiola Jackson is in the employee list with a 'manager' value of 'NULL'.

-- Using self join to compare rows within a table
-- Q: What customers are located in the same city as each other?
SELECT
    c1.city,
    c1.first_name + ' ' + c1.last_name customer_1,
    c2.first_name + ' ' + c2.last_name customer_2
FROM
    sales.customers c1
INNER JOIN sales.customers c2 ON c1.customer_id > c2.customer_id -- this ensures the statement doesn't compare the same customer
    AND c1.city = c2.city -- this matches the city
WHERE c1.city = 'Albany'
ORDER BY
    city,
    customer_1,
    customer_2;
-- The above query is good for getting a complete list of customers in the same area as each other for an internal research case.
-- However, in something like a live app or dashboard, customers would want to know who is near them from both directions.
-- The above query, using the '>' operator, does not describe that Douglass Blankenship is near Mi Gray and that Mi Gray is near Douglass Blankenship.
SELECT
    c1.city,
    c1.first_name + ' ' + c1.last_name customer_1,
    c2.first_name + ' ' + c2.last_name customer_2
FROM
    sales.customers c1
INNER JOIN sales.customers c2 ON c1.customer_id <> c2.customer_id -- this ensures the statement doesn't compare the same customer
    AND c1.city = c2.city -- this matches the city
WHERE c1.city = 'Albany'
ORDER BY
    city,
    customer_1,
    customer_2;
-- Result: Douglass Blankenship can see he is located near Mi Gray and Mi Gray can see she is located near Douglass Blankenship.
