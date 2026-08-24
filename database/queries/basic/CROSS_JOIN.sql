-- CROSS JOIN allows the combination of every row from the first table with every row of the second table.
-- It returns the *Cartesian* Product of the two tables.
-- It does not require a join condition.
-- It should be used very carefully to avoid performance issues.

-- Q: Generate a report that can be used for the stocktaking procedure at month end.
SELECT product_id, product_name, store_id, 0 AS quantity
FROM production.products
CROSS JOIN sales.stores
ORDER BY product_name, store_id;
