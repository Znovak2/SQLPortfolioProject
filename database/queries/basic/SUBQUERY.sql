-- The IN operator is a logical operator that allows you to check whether a value mathces any value in a list.
-- Subqueries can also be used in place of an expression, with IN or NOT IN, with ANY or ALL, with EXISTS or NOT EXISTS, in UPDATE, DELETE, or INSERT statements, or in the FROM clause.
-- What products are priced at $100, $199.99 or $299.99?
SELECT product_name, list_price
FROM production.products
WHERE list_price IN (100, 199.99, 299.99)
ORDER BY list_price;

-- Subqueries can be created using IN.
-- In the below example, I need to find product information for any items in store id 1 and the quantity is greater than or equal to 30.
-- First, we create the query to pull the relevant product_ids.
SELECT product_id
FROM production.stocks
WHERE store_id = 1 AND quantity >= 30
ORDER BY product_id;
-- Now, we use the above query as the subquery.
Select *
FROM production.products
WHERE product_id IN (
    SELECT product_id
    FROM production.stocks
    WHERE store_id = 1 AND quantity >= 30
)
ORDER BY product_id;

-- Q: What are the sales order details for our customers in New York state?
SELECT
    order_id,
    order_date,
    customer_id
FROM
    sales.orders
WHERE
    customer_id IN (
        SELECT customer_id
        FROM sales.customers
        WHERE city = 'New York'
    )
ORDER BY
    order_date DESC;

-- SQL Server supports at least 32 levels of nesting subqueries!
-- The below query has a double nested query
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price > (
        SELECT AVG (list_price)
        FROM production.products
        WHERE brand_id IN (
            SELECT brand_id
            FROM production.brands
            WHERE brand_name = 'Strider'
                OR brand_name = 'Trek'
        )
    )
ORDER BY
    list_price DESC;
