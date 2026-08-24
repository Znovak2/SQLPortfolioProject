-- The BETWEEN operator is a logical operator that allows you to specify a range to test.
-- The BETWEEN operator returns TRUE if the expression to test is greater than or equal to the value of the start_expression and less than or equal to the value of the end_expression.
-- NOT can be used as 'NOT BETWEEN'.

-- What products do we sell which are between $300 and $400?
SELECT *
FROM production.products
WHERE list_price BETWEEN 300 AND 400
ORDER BY list_price ASC;

-- BETWEEN can be used in conjunction with NOT
-- What products do we sell which are not in the $300-$400 range?
SELECT *
FROM production.products
WHERE list_price NOT BETWEEN 300 AND 400
ORDER BY list_price ASC;

-- BETWEEN can be used for DATE filtering
SELECT order_id, customer_id, order_date, order_status
FROM sales.orders
WHERE order_date BETWEEN '20170201' AND '20171231'
ORDER BY order_date;
