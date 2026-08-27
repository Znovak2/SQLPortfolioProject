-- A Correlated Subquery is a query which depends on the outer query for its values.
-- Correlated Subqueries are executed repeatedly for each row, then the evaluation of the outer query occurs.

-- Q: What are our highest priced items in each category?
-- It is important to note ties will impact a business question like this.
SELECT
    product_name,
    list_price,
    category_id
FROM
    production.products p1
WHERE
    list_price IN ( -- Because the return set is a single max value, '=' could argueably be a better fit in this line.
        SELECT MAX(p2.list_price)
        FROM production.products p2
        WHERE p2.category_id = p1.category_id
        GROUP BY p2.category_id
    )
ORDER BY
    category_id,
    product_name;
-- Result: Each categories highest price is identified, then each product is evaluated against that highest price in the category.
    -- Relevant results are kept, then the next category is evaluated.
    -- We now have the highest priced items per category with ties in mind.
