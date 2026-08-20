-- WHERE condition can be a logical expression or a combination of multiple logical expressions.
-- In SQL, a logical expression is also known as a Predicate.
-- WHERE works by returning rows for which the condition evaluates to TRUE.
-- WHERE is not just for SELECT statements, but also can UPDATE and DELETE at least.


-- Who are our customers in California by last name alphabetical order?
SELECT city, state, last_name, first_name, phone, email
FROM sales.customers
WHERE state = 'CA'
ORDER BY last_name DESC;

-- WHERE clause using AND operator
-- Who are our customers in Los Angeles, California by last name alphabetical order?
SELECT city, state, last_name, first_name, phone, email
FROM sales.customers
WHERE state = 'CA' AND city = 'Los Angeles'
ORDER BY last_name DESC;

-- WHERE can use a comparison operator
-- Who are our customers in the North East region of California?
SELECT city, state, zip_code, last_name, first_name, phone, email
FROM sales.customers
WHERE state = 'CA' AND zip_code > 91000
ORDER BY zip_code ASC, last_name DESC;

-- While the AND operator increases the filtering, the OR operator can expand the statement's scope.
-- Who are our customers in the North East or South West region of California territory?
-- Some business will not follow state or city lines exactly as it relates to something like sales territory or related designations.
-- In the below example, it can be assumed the business zones customer regions by zip_code.
SELECT zip_code, city, last_name, first_name, phone, email
FROM sales.customers
WHERE zip_code >= 91000 OR zip_code <=90000
ORDER BY zip_code DESC;

-- The IN operator is for filtering down to items with a specific value in a list of values
-- In the below example, the zip_code values explicitly stated is the value list.
SELECT zip_code, city, last_name, first_name, phone, email
FROM sales.customers
WHERE zip_code IN (95008,91316,92831)
ORDER BY last_name ASC;

-- The LIKE operator is used to find rows who contain a string value
-- Who are our customers with gmail email addresses?
SELECT last_name, first_name, email
FROM sales.customers
WHERE email LIKE '%gmail.com%'
ORDER BY last_name DESC;

-- NOT can be a good way to find more uncommon entries
-- Who are our customers without gmail or yahoo email addresses?
-- We need to create bespoke solutions to accommodate all our legacy customers, while not building unneccessary domain handling.
-- *This is an initial query for that answer; it could be improved with CHARINDEX() and SUBSTRING() with a COUNT() to identify the spread of the identified email domains.
SELECT email
FROM sales.customers
WHERE email NOT LIKE '%@gmail.com%'
AND email NOT LIKE '%@yahoo.com%'
ORDER BY email DESC;
