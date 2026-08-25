-- GROUP BY allows the grouping of data per designated groups.

-- Q: What years did our customers make an order?
SELECT customer_id, YEAR (order_date) order_year
FROM sales.orders
WHERE customer_id IN (1,2)
ORDER BY customer_id;
-- You can see the result set contains duplicates.
SELECT customer_id, YEAR (order_date) order_year
FROM sales.orders
WHERE customer_id IN (1,2)
GROUP BY customer_id, YEAR (order_date)
ORDER BY customer_id;
-- Now, only unique values of customer purchase years are shown. This use case is functionaly similar as the DISTINCT clause.

-- GROUP BY and aggregate functions
-- Aggregate functions perform calculations on a group and returns a unique value per group.
-- Examples of aggregate functions are: COUNT(), SUM(), AVG(), MIN(), MAX().
-- Q: How many orders did our customers place by year?
SELECT
    customer_id,
    YEAR (order_date) order_year,
    COUNT(order_id) order_count
FROM
    sales.orders
WHERE customer_id IN (1,2)
GROUP BY
    customer_id,
    YEAR (order_date)
ORDER BY
    customer_id;

-- Important note: To reference a column or expression that is not listed in the GROUP BY clause, you must use that column as the input of an aggregate function.
-- This is because there is no way to guarantee the column or expression will return a single value per group.
-- Query is commented out to prevent a purposeful error.
-- SELECT
--     customer_id,
--     YEAR (order_date) order_year,
--     order_status -- order_status is the problem here. Including a COUNT() would fix it.
-- FROM
--     sales.orders
-- WHERE
--     customer_id IN (1,2)
-- GROUP BY
--     customer_id,
--     YEAR (order_date)
-- ORDER BY
--     customer_id;

SELECT
    customer_id,
    YEAR (order_date) order_year,
    COUNT(order_status) order_count
FROM
    sales.orders
WHERE
    customer_id IN (1,2)
GROUP BY
    customer_id,
    YEAR (order_date)
ORDER BY
    customer_id;

-- More use cases:
-- Q: How many customers are in each city where we have a customer?
SELECT
    city,
    COUNT(customer_id) customer_count
FROM
    sales.customers
GROUP BY
    city
ORDER BY
    customer_count DESC;

-- Q: How many customers are in each city, state where we have at least 1 customer.
SELECT
    city,
    state,
    COUNT (customer_id) customer_count
FROM
    sales.customers
GROUP BY
    city,
    state -- even though state is a higher granularity than the city, it is required to be in the GROUP BY clause.
ORDER BY
    customer_count DESC;

-- Using the MIN() and MAX() functions.
-- Q: What are the minimum and maximum prices for all 2018 model products by brand?
SELECT
    brand_name,
    MIN (list_price) min_price,
    MAX (list_price) max_price
FROM
    production.products p
INNER JOIN production.brands b ON b.brand_id = p.brand_id
WHERE -- processed before the group by clause
    model_year = 2018
GROUP BY
    brand_name
ORDER BY
    brand_name;

-- Using the AVG() function
-- Q: What is the average price for all 2018 model products by brand?
SELECT
    brand_name,
    AVG(list_price) avg_price
FROM
    production.products p
INNER JOIN production.brands b ON b.brand_id = p.brand_id
WHERE
    model_year = 2018
GROUP BY
    brand_name
ORDER BY
    brand_name;

-- Using the SUM() function
-- Q: What is the net value of every order?
SELECT
    order_id,
    SUM(
        quantity * list_price * (1 - discount)
    ) AS net_value
FROM
    sales.order_items
GROUP BY
    order_id;
