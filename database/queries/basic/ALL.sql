-- The SQL Server ALL operator is a logical operator that compares a scalar value with a single-column list of values returned by a subquery.

-- Q: What is the average list price for the products for each brand?
SELECT
    AVG (list_price) avg_list_price
FROM
    production.products
GROUP BY
    brand_id
ORDER BY
    avg_list_price DESC;

-- Using "> ALL": The expression returns TRUE if the scalar_expression is greater than the largest value returned by the subquery.
-- Q: Which products have a price which is better than the average list price of products of all brands?
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price > ALL ( -- Here.
        SELECT AVG(list_price) avg_list_price
        FROM production.products
        GROUP BY brand_id
    )
ORDER BY
    list_price DESC;

-- Using "< ALL": The expression evaluates to TRUE if the scalar expression is smaller than the smallest value returned by the subquery.
-- Q: Which products have a price which is less than the smallest price in the average price list by brand?

SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price < ALL (
        SELECT AVG(list_price) avg_list_price
        FROM production.products
        GROUP BY brand_id
    )
ORDER BY
    list_price DESC;
