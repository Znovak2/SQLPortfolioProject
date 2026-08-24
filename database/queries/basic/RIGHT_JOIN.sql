-- The RIGHT JOIN clause combines data from two or more tables; it starts selecting data from the right table and matching it with the rows from the left table.
-- If a row in the right table does not have any matching rows from the left table, the left table values in the result set will be NULL.
-- Q: What are our total order details?
SELECT i.order_id 'Order ID', p.product_name 'Product Name'
FROM sales.order_items i
RIGHT JOIN production.products p
    ON i.product_id = p.product_id
ORDER BY i.order_id ASC;

-- Q: What products of ours have never been included in an order?
SELECT i.order_id 'Order ID', p.product_name 'Product Name'
FROM sales.order_items i
RIGHT JOIN production.products p
    ON i.product_id = p.product_id
WHERE order_id IS NULL
ORDER BY order_id ASC;
