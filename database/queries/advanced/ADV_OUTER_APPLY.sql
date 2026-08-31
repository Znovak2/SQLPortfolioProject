-- The OUTER APPLY clause allows you to perform a left join of a table with a table-valued function or a correlated subquery.
-- Works similar to LEFT JOIN, but includes the table-valued function or correlated subquery.

-- Using OUTER APPLY to join a table with a table-valued function:
-- Q: What is the product name, qunatity and discount of the products from brand number 1?
CREATE OR ALTER FUNCTION GetLatestQuantityDiscount (@product_id INT) -- CREATE OR ALTER makes this easily re-runnable
RETURNS TABLE
AS RETURN (
  SELECT
    TOP 1 i.*
  FROM
    sales.order_items i
    INNER JOIN sales.orders o ON o.order_id = i.order_id
  WHERE
    product_id = @product_id
  ORDER BY
    order_date DESC
);
GO -- GO is used to end the create function batch.

SELECT
  p.product_name,
  r.quantity,
  r.discount
FROM
  production.products p
OUTER APPLY GetLatestQuantityDiscount(p.product_id) r -- referenced function
WHERE
  p.brand_id = 1
ORDER BY
  r.quantity;
-- Result: The most recent price and discount is returned for all brand 1 bikes, while those brand 1 bikes not orderd yet has NULL values.

-- OUTER APPLY examples:
-- Q: What is the product name, qunatity and discount of the products from brand number 1?
SELECT
    p.product_name,
    r.quantity,
    r.discount
FROM
    production.products p OUTER APPLY (
        SELECT top 1 i.*
        FROM sales.order_items i
        INNER JOIN sales.orders o ON o.order_id = i.order_id
        WHERE product_id = p.product_id
        ORDER BY order_date DESC
    ) r
WHERE
    p.brand_id = 1
ORDER BY
    r.quantity;
-- Result: The most recent price and discount is returned for all brand 1 bikes, while those brand 1 bikes not orderd yet has NULL values.
