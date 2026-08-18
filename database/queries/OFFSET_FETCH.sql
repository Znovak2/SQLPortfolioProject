-- OFFSET will return values only after N, while FETCH will return N rows after OFFSET completes.
-- This method is preferred over TOP

-- What is a randomly sampled dataset of our orders for further analysis?

-- Step 0
-- Basic starting dataset
SELECT *
FROM sales.orders
ORDER BY order_date DESC, shipped_date DESC;

-- Step 1
-- Pull the rows after the 10 most recent entries
SELECT *
FROM sales.orders
ORDER BY order_date DESC, shipped_date DESC
OFFSET 10 ROWS;

-- Step 2
-- Cap the returned rows to 3 
SELECT *
FROM sales.orders
ORDER BY order_date DESC, shipped_date DESC
OFFSET 10 ROWS
FETCH NEXT 3 ROWS ONLY;