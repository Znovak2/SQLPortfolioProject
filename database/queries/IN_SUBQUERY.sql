-- The IN operator is a logical operator that allows you to check whether a value mathces any value in a list.

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
