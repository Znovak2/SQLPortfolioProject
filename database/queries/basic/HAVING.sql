-- HAVING is often used with the GROUP BY clause to filter *groups* based on a specific list of conditions.
-- It is important to note, aggregation predicates need to be included in the HAVING clause since the column alias in the select predicate is not yet created.
-- Q: Which customers had more than two orders per year, including which year?
SELECT
    customer_id,
    YEAR (order_date),
    COUNT(order_id) order_count
FROM
    sales.orders
GROUP BY
    customer_id, -- Group by customer id
    YEAR (order_date) -- add the year granularity
HAVING
    COUNT (order_id) >= 2
ORDER BY
    customer_id;

-- HAVING with SUM() function
-- Q: Which orders had net values greater than $20,000?
SELECT
    order_id,
    SUM(quantity * list_price * (1-discount)) net_value -- includes the actually order value in the result set
FROM
    sales.order_items
GROUP BY
    order_id -- Reduces the granularity to get order's net value.
HAVING
    SUM(quantity * list_price * (1-discount)) > 20000 -- creates a condition to filter groups.
ORDER BY
    net_value DESC;

-- HAVING with MAX() and MIN() functions
-- What are our maximum and minimum prices in each category to show which categories might have unusual price ranges?
SELECT
    category_id,
    MAX(list_price) max_list_price,
    MIN(list_price) min_list_price
FROM
    production.products
GROUP BY
    category_id
HAVING
    MAX (list_price) > 4000
        OR MIN(list_price) < 500
ORDER BY
    category_id ASC;

-- HAVING with AVG() function
-- Q: Which product categories have an average price between $500 and $1,000?
SELECT
    category_id,
    AVG(list_price) avg_list_price
FROM
    production.products
GROUP BY
    category_id
HAVING
    AVG(list_price) BETWEEN 500 and 1000
ORDER BY
    category_id ASC;
