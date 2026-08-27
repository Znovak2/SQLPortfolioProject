-- The IN operator is a logical operator that allows you to check whether a value mathces any value in a list.
-- IN can be used to nest subqueries.
-- Subqueries can also be used in place of an expression, with IN or NOT IN, with ANY or ALL, with EXISTS or NOT EXISTS, in UPDATE, DELETE, or INSERT statements, or in the FROM clause.

-- Basic IN usage:
-- Q: What products are priced at $100, $199.99 or $299.99?
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

-- Q: Find all products with a category of Road Bike or Mountain Bike.
SELECT
    product_id,
    product_name
FROM production.products
WHERE category_id
    IN (
        SELECT category_id
        FROM production.categories
        WHERE category_name = 'Mountain Bikes'
            OR category_name = 'Road Bike'
    );

-- SQL Server supports at least 32 levels of nesting subqueries!
-- The below query has a double nested query
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price > (
        SELECT AVG (list_price) -- First nested statement
        FROM production.products
        WHERE brand_id IN (
            SELECT brand_id -- Second nested statement
            FROM production.brands
            WHERE brand_name = 'Strider'
                OR brand_name = 'Trek'
        )
    )
ORDER BY
    list_price DESC;

-- Q: What is the highest price of an item for each order?
SELECT
    order_id,
    order_date,
    (
        SELECT MAX(list_price)
        FROM sales.order_items i
        WHERE i.order_id = o.order_id -- enables the selecting of highest list_price for every order_id, not just the highest list_price overall.
    ) AS max_list_price
FROM sales.orders o
ORDER BY order_id ASC;

-- The ANY operator means the subquery predicate only needs one TRUE evaluation results.
-- Q: What products have a price higher than any brand's average price.
SELECT
    product_id,
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price >= ANY(
        SELECT AVG(list_price)
        FROM production.products
        GROUP BY brand_id
    );

-- The ALL operator means all the subquery predicates must evaluate as TRUE.
-- ALL has the same syntax as ANY.
-- Q: A premium product is one which has a price higher than all brand's average price. What are out premium products?
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price >= ALL (
        SELECT AVG(list_price)
        FROM production.products
        GROUP BY brand_id
    )
ORDER BY list_price DESC;

-- The EXISTS operator will evaluate to true if the query returns any results.
-- Q: Which customers bought product in 2017?
SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM
    sales.customers c
WHERE
    EXISTS(
        SELECT customer_id
        FROM sales.orders o
        WHERE o.customer_id = c.customer_id
            AND YEAR (order_date) = 2017
    )
ORDER BY
    last_name,
    first_name;
-- Conversly, the NOT operant can be used to negate the EXISTS clause
-- Q: Which customers did NOT buy product in 2017?
SELECT
    customer_id,
    first_name,
    last_name,
    city
FROM
    sales.customers c
WHERE
    NOT EXISTS( -- NOT changes the logic here
        SELECT customer_id
        FROM sales.orders o
        WHERE o.customer_id = c.customer_id
            AND YEAR (order_date) = 2017
    )
ORDER BY
    last_name,
    first_name;

-- Since query result sets are like virtual tables, they can be used in the FROM clause.
-- Q: What is the average order count per employee?
-- First, we need to get the order count per employee:
SELECT
    staff_id,
    COUNT(order_id) order_count
FROM
    sales.orders
GROUP BY
    staff_id;
-- Second, let's average the result set above:
SELECT
    AVG(order_count) average_order_count_by_staff
FROM
    (
        SELECT
            staff_id,
            COUNT(order_id) order_count
        FROM
            sales.orders
        GROUP BY
            staff_id
    )
t; -- Table alias is required for this method
