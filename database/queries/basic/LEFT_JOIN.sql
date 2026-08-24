-- LEFT JOIN returns all rows from the left table, in combination with the applicable, matched rows from the right table.
-- Q: Generate a product report of sales orders.
SELECT product_name, model_year, order_id
FROM production.products p
LEFT JOIN sales.order_items o ON o.product_id = p.product_id
ORDER BY order_id;

-- Q: What products have not been sold yet?
SELECT product_name, model_year, order_id
FROM production.products p
LEFT JOIN sales.order_items o ON o.product_id = p.product_id
WHERE order_id IS NULL
ORDER BY model_year DESC;

-- Q: What is our recent order information?
SELECT p.product_name, p.model_year, o.order_id, o.order_date, i.item_id
FROM production.products p
LEFT JOIN sales.order_items i ON i.product_id = p.product_id
LEFT JOIN sales.orders o ON i.order_id = o.order_id
ORDER BY order_date DESC; -- Table alias is optional here because order_date is only in one joined table.

-- The ON condition within the LEFT JOIN can increase report scope, while retaining filtering requirements.
SELECT product_name, order_id
FROM production.products p
LEFT JOIN sales.order_items o
    ON o.product_id = p.product_id
WHERE order_id = 100
ORDER BY order_id DESC;
-- The result set is 5 entries long since the products with NULL order_ids were filtered out.
SELECT product_name, order_id
FROM production.products p
LEFT JOIN sales.order_items o
    ON o.product_id = p.product_id
        AND o.order_id = 100
ORDER BY order_id DESC;
-- The result set now includes all product names, while retaining order id for only those which are 100.

