-- The SQL Server EXCEPT compares the result sets of two queries and returns the distinct rows from the first query that are not output by the second query.

-- Q: Which products have no sales?
SELECT product_id -- cannot include product_name since it does not exist in both tables
FROM production.products
EXCEPT
SELECT
    product_id
FROM
    sales.order_items;

