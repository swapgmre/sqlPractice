-- WINDOW FUNCTIONS OR ANALYTICAL FUNCTIONS
-- Very Important functions 

-- What and Why Window ?
-- WINDOW vs GROUP BY

-- WINDOW Functions
-- They are functions that allow to perform calculations(e.g.aggregation) 
-- on a specific subset of data,
-- without losing the level of details of rows.


-- GROUP BY  - Returns a single row for each group
-- Changes the granularity
-- For simple aggregations use GROUP BY
-- Has Aggregate Functions
-- Simple Data Analysis

-- WINDOW - Returns a result for each row
-- The granularity stays the same
-- Aggregations + keep details
-- Has Aggregate functions, Rank Functions, Value or Analytics functions
-- Advanced Data Analysis

-- Why we need WINDOW Functions ?
-- Why GROUP BY is not enough ?

-- Find the total sales across all orders
-- USE SalesDB

SELECT
SUM(Sales) TotalSales
FROM Sales.Orders

-- Find the total sales for each product
SELECT
ProductID,
SUM(Sales) TotalSales
FROM Sales.Orders
GROUP BY ProductID

-- ** Result Granularity - The number of rows in the output
-- is defined by the dimension

/*Find the total sales for each product 
Additionally provide details such as orderId, order date*/

-- GROUP BY Rule - All columns in SELECT must be included in group by
-- GROUP BY Limits - Can't do aggregations and provide details at same time

SELECT
OrderID,
OrderDate,
ProductID,
SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProducts
FROM Sales.Orders

-- Result Granularity  - Window functions returns a result for each row

-- Window Function Syntax
/* 
Basic parts of windows functions  - mainly we have two parts 
the WINDOW function and the second part will be the Over Clause.
OVER clause has three different parts
- PARTITION Clause
- ORDER Clause
- Frame Clause


ex.

AVG(Sales) OVER(PARTITION BY Category ORDER BY OrderDate ROWS UNBOUNDED PRECEDING)

*/

-- Find the total sales across all orders additionally provide details
-- such as order id & order date

SELECT
OrderID,
OrderDate,
SUM(Sales) OVER () AS TotalSales
FROM Sales.Orders

-- Find the total sales for each product, additionally provide details
-- such as order id & order date
SELECT
OrderID,
OrderDate,
ProductID,
SUM(Sales) OVER (PARTITION BY ProductID) AS TotalSalesByProduct
FROM Sales.Orders

-- Find the total sales across all orders
-- Find the total sales for each product, additionally provide details
-- such as order id & order date

SELECT
OrderID,
OrderDate,
ProductID,
Sales,
SUM(Sales) OVER () AS TotalSales,
SUM(Sales) OVER (PARTITION BY ProductID) AS TotalSalesByProduct
FROM Sales.Orders

-- Flexibility of Window - Allows aggregation of data at different granulartities within the same query




-- Find the total sales across all orders
-- Find the total sales for each product
-- Find the total sales for each combination of product and order status
-- Additionally provide details such as order id & order date

SELECT
OrderID,
OrderDate,
ProductID,
OrderStatus,
Sales,
SUM(Sales) OVER () AS TotalSales,
SUM(Sales) OVER (PARTITION BY ProductID) AS SalesByProduct,
SUM(Sales) OVER (PARTITION BY ProductID, OrderStatus) SalesByProductsAndStatus
FROM Sales.Orders



-- ORDER BY in WINDOWS
-- FOR RANK and VALUE Functions ORDER BY is required

-- Rank each order based on their sales from highest to lowest,
-- Additionally provide details such as orderID, orderDate


SELECT
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER (ORDER BY Sales DESC) RankSales
FROM Sales.Orders


-- WINDOWS FRAME - ROWS, UNBOUNDED, PRECIDING
-- Defines a subset of rows within each window that is relevant for the calculation
-- Rules - Frame Clause can only be used together with order by clause.
-- Lower Value must be Before the higher value.

SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate 
ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) TotalSales
FROM Sales.Orders

-- COMPACT FRAME
-- For only PRECEDING, the CURRENT ROW can be skipped 
-- NORMAL FORM: ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
-- SHORT FORM: ROWS 2 FOLLOWING

SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate 
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) TotalSales
FROM Sales.Orders

-- WITH COMPACT FRAME SAME QUERRY

SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate 
ROWS 2 PRECEDING) TotalSales
FROM Sales.Orders

-- DEFAULT FRAME below commented is what looks like 
SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
)TotalSales
FROM Sales.Orders

-- 4 Rules or  Limitations
-- #1 Winodw function can be used Only in SELECT and ORDER BY Clauses.
-- This means WINDOW functions cannot be used to filter Data

SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus) TotalSales
FROM Sales.Orders
ORDER BY SUM(Sales) OVER (PARTITION BY OrderStatus) DESC

-- #2 Rule
-- Nesting Window Functions is not allowed !

-- #3 Rule
-- SQL execute WINDOW functions after WHERE clause

-- Find the total sales for each order status, only for two products 101 and 102
-- In below example WHERE clause is executed first and later the WINDOW function
SELECT
OrderID,
OrderDate,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus) TotalSales
FROM Sales.Orders
WHERE ProductID IN (101, 102)

-- #4 Rule
-- Window Function can be used together with GROUP BY 
-- in the same query, ONLY if the same columns are used

-- Rank customers based on their total sales
-- Note - Use GROUP BY for simple Aggregations

-- Step 1: Add GROUP BY to the query
-- Step 2 : Add WINDOW function to teh query

SELECT
	CustomerID,
SUM(Sales) TotalSales,
RANK() OVER(ORDER BY SUM(Sales) DESC) RankCustomers
FROM Sales.Orders
GROUP BY CustomerID
