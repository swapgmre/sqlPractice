-- NULL FUNCTIONS - NULL means nothing, unknown!
-- NULL is not equal to anything!
-- NULL is not zero
-- NULL is not empty string
-- NULL is not blank space

-- Replacing NULL
-- How to handle nulls inside our data?

-- to replace NULL we have two function ISNULL and COALESCE

-- replacing a value to a NULL we use NULLIF

-- To Check
-- IS NULL gives boolean
-- IS !NULL gives boolean

-- ISNULL - Replaces 'NULL' with a specified value
-- ISNULL(value, replacement_value)
-- ex. ISNULL(Shipping_Address, 'unknown') 
-- 1st value is a column and 2nd a static unknown - default value
-- ex. ISNULL(Shipping_Address, Billing_Address)
-- 1st value is column and 2nd value is a column
-- **if the replace value ISNULL it is going to return null but if we want to replace the NULL we have to provide a static value


-- COALESCE
-- Returns the first non-null value from a list
-- COALESCE(value1, value2, value3, ...)
-- we can still use it like ISNULL
-- COALESCE(Shipping_Address, 'unknown')
-- COALESCE(Shipping_Address, Billing_Address)
-- COALESCE(Shipping_Address, Billing_Address, 'unknown')
-- so if billing address is NULL go check the static value 

-- ISNULL vs COALESCE
-- Limited to two values |	Unlimited
-- Performance - Fasr    |  Slow
-- Different keyword for different database for ISNULL
-- SQL Server - ISNULL	 | 	 Coalesce is available in all different databases
-- Oracle - NVL			 |		
-- MySQL - IFNULL        |

-- USE CASE - Handling NULLS
-- 1) DATA Aggregation
-- Handle the NULL before doing data aggregations 

-- Find the average scores of the customers 

SELECT
	CustomerID,
	Score,
	COALESCE(Score,0) Score2,
	AVG(Score) OVER () AvgScores,
	AVG(COALESCE(Score,0)) OVER() AvgScore2
FROM Sales.Customers

-- 2)Mathematial Operations
-- Handle the NULL before doing mathematical operations

-- Dipslay the full name of customers in a single field
-- by merging their first and last names,
--  and add 10 bonus points to each customer's score

SELECT
	CustomerID,
	FirstName,
	LastName,
	FirstName + ' ' + COALESCE(LastName, '') AS FullName,
	Score,
	COALESCE(Score, 0) + 10 AS ScoreWithBonus
	FROM Sales.Customers

-- ** 3) JOINS
-- ** Handle the NULL before JOINING tables
-- SQL Cannot go and use the equal operator in order to join tables, sql cannot compares the null and ignores it and is not printed in results
-- So we have to replace the NULL with empty string or other values. Empty string is faster
-- But in result we will not get empty string but NULL and that is because we are handling the NULL only on the joins and not on the select and on the select the original data will be the original data and it was NULL

-- 4) SORTING DATA 
-- Handle the NULL before sorting data
-- When using ORDER BY ASC NULL will be on the lowest and during DESC it will show as Highest

-- Sort the customers from lowest ot highest scores with NULLs appearing last

-- Method 1 - Replacing Nulls with very Big Number

SELECT
CustomerID,
Score,
COALESCE(Score, 9999999)
FROM Sales.Customers
ORDER BY COALESCE(Score, 9999999)


-- Method 2 - Replacing Nulls with CASE WHEN AND FLAG

SELECT
CustomerID,
Score
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN  1 ELSE 0 END, Score

-- NULLIF()
-- Compares two expressions returns:
-- a) NULL, if they are equal
-- b) First Value, if they are not equal.

-- NULLIF(value1, Valu2)
-- ex. NULLIF(Shipping_Address, 'unknown')
-- ex. NULLIF(Shipping_Address, Billing_Address)

-- NULLIF USECASE
-- 1) Division by zero - Preventing the error of dividing by zero
-- Find the sales price for each order by dividing the sales by the quantity.

SELECT
OrderID,
Sales,
Quantity,
Sales/NULLIF(Quantity,0) AS Price
FROM Sales.Orders


-- IS NULL - Returns TRUE if the value is IS NULL,
-- otherwise it returns FALSE.

-- IS NOT NULL - Returns TRUE if the value IS NOT NULL, otherwise it returns FALSE.
-- Value IS NULL
-- Value IS NOT NULL
-- ex. Shipping_Address IS NULL
-- ex. Shipping_Address IS NOT NULL

-- IS NULL USECASE - IS NULL | IS NOT NULL
-- FILTERING DATA - SEarching for misssing information
-- Identify the customers who have no scores

SELECT
*
FROM Sales.Customers
WHERE Score IS NULL

-- List all customers who have scores
SELECT
*
FROM Sales.Customers
WHERE Score IS NOT NULL

-- IS NULL USE CASE
-- ANTI JOINS - LEFT ANTI and RIGHT ANTI
-- Finding the unmatched rows between two tables
-- LEFT ANTI JOIN ALSO - LEFT JOIN + IS NULL
-- RIGHT ANTI JOIN - RIGHT JOIN + IS NULL

-- List all details for customers who have not placed any orders

SELECT
c.*,
o.OrderID
FROM Sales.Customers c
LEFT JOIN Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL


