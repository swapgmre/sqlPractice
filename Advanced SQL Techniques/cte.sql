-- CTE - Common Table Expression
-- Temporary, named result set (virtual table), 
-- that can be used multiple times within your query
-- to simplify and organize complex query.

-- When and Why to use CTE ?


-- Types of CTEs
-- #1 Non-Recursive CTE
-- 2 Subtypes 
-- a)Standalone CTE b) Nested CTE


-- #2 Recursive CTE


-- Standalone CTE
-- Defined and Used independently.
-- Runs independently as it's self-contained and doesn't rely
-- on other CTEs or queries.

/*
CTE Syntax

WITH CTE-Name AS   --> CTE Query - CTE Definition
( 
SELECT...
FROM...
WHERE...
)

SELECT...
FROM CTE-Name
WHERE ...

*/

-- Step 1: Find the total sales per customer.



WITH CTE_Total_Sales AS 
(
SELECT
CustomerID,
SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
)
-- Main Query
SELECT
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID
ORDER BY CustomerID


-- ***CTE-Rule: You cannot use ORDER BY directly within the CTE

-- Multiple Standalone CTEs
/* 
Snytax for Multiple Standalone CTEs

WITH CTE-Name1 AS
(
	SELECT ...
	FROM ...
	WHERE ...
) 
, CTE-Name2 AS
(
	SELECT ...
	FROM ...
	WHERE ...
) 
 SELECT ...
 FROM CTE-Name1
 JOIN CTE-Name2
 WHERE...

*/

-- Step2 : Find the last order date for each customer (Standalone CTE)

WITH CTE_Total_Sales AS 
(
SELECT
	CustomerID,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
)
, CTE_Last_Order AS
(
SELECT
	CustomerID,
	MAX(OrderDate) AS Last_Order
FROM Sales.Orders
GROUP BY CustomerID
)
-- Main Query
SELECT
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
clo.Last_Order
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order clo
ON clo.CustomerID = c.CustomerID


-- Nested CTE
-- CTE inside another CTE
-- A nested CTE uses the result of another CTE, so it can't run independently.

/*
Syntax Nested - CTE 

WITH CTE-Name1 AS --> first CTE is called as Standalone CTE
(
	SELECT...
	FROM...
	WHERE...
)
, CTE-Name2 AS  --> Nested CTE
(
	SELECT...
	FROM CTE-Name1
	WHERE...
)
SELECT ...      --> Main Query
FROM
WHERE

*/

-- Step3: Rank Customers based on Total Sales Per Customer (Nested CTE)

WITH CTE_Total_Sales AS 
(
SELECT
	CustomerID,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
)
, CTE_Last_Order AS
(
SELECT
	CustomerID,
	MAX(OrderDate) AS Last_Order
FROM Sales.Orders
GROUP BY CustomerID
)
, CTE_Customer_Rank AS
(
SELECT
CustomerID,
TotalSales,
RANK() OVER (ORDER By TotalSales DESC) AS CustomerRank
FROM CTE_Total_Sales
)
-- Main Query
SELECT
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
clo.Last_Order,
ctr.CustomerRank
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order clo
ON clo.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Rank ctr
ON ctr.CustomerID = c.CustomerID


-- Step 4: Segment customers based on their total sales (Nested CTE).

WITH CTE_Total_Sales AS 
(
SELECT
	CustomerID,
	SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY CustomerID
)
, CTE_Last_Order AS
(
SELECT
	CustomerID,
	MAX(OrderDate) AS Last_Order
FROM Sales.Orders
GROUP BY CustomerID
)
, CTE_Customer_Rank AS
(
SELECT
CustomerID,
TotalSales,
RANK() OVER (ORDER By TotalSales DESC) AS CustomerRank
FROM CTE_Total_Sales
)
, CTE_Customer_Segment AS
(
SELECT
CustomerID,
CASE WHEN TotalSales > 100 THEN 'High'
	 WHEN TotalSales > 50  THEN 'Medium'
	 ELSE 'Low'
END CustomerSegments
FROM CTE_Total_Sales
)
-- Main Query
SELECT
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
clo.Last_Order,
ctr.CustomerRank,
ccs.CustomerSegments
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order clo
ON clo.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Rank ctr
ON ctr.CustomerID = c.CustomerID
LEFT JOIN CTE_Customer_Segment ccs
ON ccs.CustomerID = c.CustomerID

-- CTE Best Practices
-- Rethink and refactor your CTEs before starting a new one.
-- Don't use more than 5 CTEs in one query; otherwise, your code will
-- be hard to understand and maintain.

-- Recursive CTE
-- Self- referencing query that repeatedly processes data until a specific condition met.
-- We usually use recursive CTE if we have hiarchial structure and we want to navigate or travel thrugh the hiearchy.