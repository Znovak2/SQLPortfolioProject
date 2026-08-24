-- INNER JOIN returns rows only which are in both tables.

-- Q: What are our products with a literal category column?
SELECT product_id, product_name, category_id, list_price
FROM production.products
ORDER BY product_id;
-- The above query returns only a category_id numeric value, so we join on the categories table (table 2) to enrich table 1.
SELECT product_id, product_name, category_name, list_price
FROM production.products p
INNER JOIN production.categories c -- INNER keyword is optional; it can be just 'JOIN' for this specific case.
    ON p.category_id = c.category_id -- equality is evaluated the same both ways so the table order in the ON condition does not matter.
ORDER BY product_id;

-- INNER JOINS can be combined to query data from more than 2 tables.
SELECT product_id, product_name, category_name, brand_name, list_price
FROM production.products p
INNER JOIN production.categories c ON c.category_id = p.category_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
ORDER BY product_id;
