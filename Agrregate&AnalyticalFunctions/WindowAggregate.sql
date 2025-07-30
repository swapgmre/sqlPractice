-- Aggregate Window Function

/* 
Syntax

AVG(Sales) OVER (PARTITION BY ProductID ORDER BY Sales)

-- Expression is required
-- Partition By is Optional
-- Order By is Optional

-- ** look for baras pdf for detailed explanation


- COUNT(*) Aslo some people use COUNT(1) which same as COUNT(*)
- counts all the rows in a table, regardless of whether any value is NULL

Find the total number of Orders for each product

COUNT(*) OVER(PARTITION BY Product) 
As we are not specifying what to count it will count the whole row and will give output
even if some values are NULL.


Find the total number of Sales for each product

COUNT(Sales) OVER(PARTITION BY Product)
Here we are counting over Sales and sales have a NULL so where it is NULL it will ignore and give resutl excluding the NULL.

- COUNT(column)
- counts the number of non-NULL values in the column

COUNT (any data type) takes any data types

COUNT(Product) OVER(PARTITION BY Product)
*****NOTE : Counts the total number of rows including duplicates, not the unique values!

*/ 

-- Find the total number of Orders

SELECT
COUNT(*) TotalOrders
FROM Sales.Orders

-- #1 USE CASE - OVERALL ANALYSIS
-- Quick summary or snapshot of the entire dataset

-- Find the total number of Orders
-- Additionally provide details such as order id & order date

SELECT
	OrderID,
	OrderDate,
	COUNT(*) OVER() TotalOrders
FROM Sales.Orders

-- #2 USE CASE - TOTAL PER GROUPS
-- Group-wise analysis, to understand patterns within different categories

-- Find the total number of Orders
-- Find the total number of Orders for each cusotmers
-- Additionally provide details such as order id & order date

SELECT
	OrderID,
	OrderDate,
	CustomerID,
	COUNT(*) OVER() TotalOrders,
	COUNT(*) OVER(PARTITION BY CustomerID) OrdersByCustomers
FROM Sales.Orders

-- Find the total number of Customers
-- Additionally provide All customers Details

SELECT
*,
COUNT(*) OVER () TotalCustomers
FROM Sales.Customers

-- #3 USE CASE - DATA QUALITY CHECK
-- Detecting number of NULLS by comparing to total number of rows

-- Find the total number of Customers
-- Find the total number of scores for the customers
-- Additionally provide All customers Details


SELECT
*,
COUNT(*) OVER () TotalCustomers,
COUNT(Score) OVER () TotalScores,
COUNT(Country) OVER() TotalCountries
FROM Sales.Customers

-- #4 USE CASE - Identify Duplicates
-- Identify duplicate rows to improve data quality
-- DATA QUALITY ISSUE
-- Duplicates leads to inaccuracies in analysis
-- COUNT() can be used to identify duplicates

-- Check whether the table 'Orders' contains any duplicate rows

SELECT
*
FROM Sales.Orders

-- BY Checking out the table orders in SQL there are many orders but how to find the duplicates
-- STEP #1 - What is the Primary Key of the table orders
-- We go check the data model if there is one and check for primary key which should be unique and not duplicate


SELECT
OrderID,
COUNT(*) OVER(PARTITION BY OrderID) CheckPK
FROM Sales.Orders

SELECT
*
FROM (
SELECT
OrderID,
COUNT(*) OVER(PARTITION BY OrderID) CheckPK
FROM Sales.OrdersArchive) t
WHERE CheckPK > 1

-- Divides the data by the primary Key (OrderID)
-- Expectation - Maximum number of rows for each window (ID) = 1
-- Anything over 1 has a duplicaate


-- SUM()
-- Returns the sum of values within a window
-- ** SUM() accepts only Numbers

-- #1 USE CASE - OVERALL ANALYSIS
-- Quick summary or snapshot of the entire dataset

-- Find the total sales across all orders
-- and the total sales for each product.
-- Additionally, provide details such as orderID and order date.



SELECT
OrderID,
OrderDate,
Sales,
ProductID,
SUM(Sales) OVER() TotalSales,
SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesByProduct
FROM Sales.Orders

-- COMPARISON ANALYSIS
-- Comparison Use Cases

-- Compare the current value and aggregated value of window functions
-- ex. comapre current value of month of Mar and sales is 30 we are comapring
-- the current sales value 30 to an aggregated value ex 175 using SUM		
-- We call this analysis as Part-to-Whole Analysis
-- Compare current sales  to total sales

-- Compare to Extemes Analysis
-- Compare current sales to the highest or lowest sales

-- Compare to Average Analysis
-- Help to evaluate whether a value is above or below the average

-- ** This analysis are very important to study and understand the performance of current data

-- Find the percentage contribution of each product's sales to the total sales

-- #3 USE CASE - Part-To-Whole Analysis
-- shows the contribution of each data point to the overall data


SELECT
OrderID,
ProductID,
Sales,
SUM(Sales) OVER() TotalSales,
ROUND(CAST (Sales AS Float) / SUM(Sales) OVER() * 100, 2) PercentageOfTotal
FROM Sales.Orders

-- Problem - Dividing two integer columns produces an integer, not a decimal
-- Convert Sales to float


-- AVG - Returns the average of values	within a window 

-- Find the average sales across all orders
-- And Find the average sales for each product
-- Additionally provide details such as order Id,order date


SELECT
OrderId,
OrderDate,
Sales,
ProductID,
AVG(Sales) OVER() AvgSales,
AVG(Sales) OVER(PARTITION BY ProductID) as AvgSalesByProduct
FROM Sales.Orders


-- #1 USE CASE - OVERALL ANALYSIS
-- Quick summary or snapshot of the entire dataset


-- #2 USE CASE - Total Per Groups
-- Group-wise analysis, to understand patterns within 
-- different categories


-- Find the average scores of customers
-- Additionally provide details such as CustomerID and LastName

SELECT
CustomerID,
LastName,
Score,
COALESCE(Score,0) CustomerScore,
AVG(Score) OVER () AvgScore,
AVG(COALESCE(Score,0)) OVER() AvgScoreWithNull
FROM Sales.Customers

-- Comparison Analysis
-- Find all orders where sales are higher 
-- than the average sales across all orders.

SELECT
*
FROM(
SELECT
OrderID,
OrderDate,
ProductID,
Sales,
AVG(Sales) OVER() AvgSales
FROM Sales.Orders
)t WHERE Sales > AvgSales

-- #3 USE CASE - Compare to Average
-- Helps to evaluate whether a value is above or below the avergae
-- 
-- WINDOW RULE - Window function's can't be used in the WHERE clause
-- So we will use Subquery

-- MIN/MAX
-- MIN() - Returns the lowest value within a window
-- MAX() - Retuns the highest value within a window

-- Find the highest and lowest sales of all orders
-- Find the highest and lowest sales for each product
-- Additionally provide details such order Id, order date


SELECT
OrderId,
OrderDate,
ProductID,
Sales,
MAX(Sales) OVER() HighestSales,
MIN(Sales) OVER() LowestSales,
MAX(Sales) OVER(PARTITION BY ProductID) HighestSalesByProduct,
MIN(Sales) OVER(PARTITION BY ProductID) LowestSalesByProduct
FROM Sales.Orders

-- #1 USE CASE - OVERALL ANALYSIS
-- Quick Summary or Snapshot of the entire dataset

-- #2 USE CASE - Total Per Groups
-- Group-wise analysis, to understand pattern within different categories

-- Filtering data with MIN/MAX
-- Show the employees who have the higest salaries


SELECT
*
FROM
(SELECT
*,
MAX(Salary) OVER() HighestSalary
FROM Sales.Employees
)t WHERE Salary = HighestSalary;


-- Calculate the deviation of each sale from both the minimum and 
-- maximum sale amounts.

SELECT
OrderId,
OrderDate,
ProductID,
Sales,
MAX(Sales) OVER() HighestSales,
MIN(Sales) OVER() LowestSales,
Sales - MIN(Sales) OVER() DeviationFromMin,
MAX(Sales) OVER() - Sales DeviationFromMax
FROM Sales.Orders

-- #3 USE CASE - Compare to Extremes (Deviation)
-- Help to evaluate how well a value is performing relative to the extremes
-- Distance From Extreme - The lower the deviation, the closer the data point is to the extreme

-- ANALYTICAL USE CASE
-- RUNNING & ROLLING TOTAL
-- The key USE CASE for both the concept is to do TRACKING
-- TRACKING - Tracking Current Sales with Target Sales
-- Also for TREND ANALYSIS - Providing insights into historical patterns

-- RUNNING & ROLLING TOTAL
-- They aggregate sequence of members, and the aggregation is updated each time a new member is added
-- This sequence is also called as ANALYSIS OVER TIME

-- RUNNING TOTAL vs ROLLING TOTAL

-- RUNNING TOTAL
-- Aggregate all values from the beginning up to the current point
-- without dropping off older data.

-- ROLLING/SHIFTING WINDOW TOTAL
-- Aggregate all values within a fixed time window (e.g.30days).
-- As new data is added, the oldest data point will be dropped.

-- MOVING AVERAGE
-- Calculate the moving/running average of sales for each product over time 
-- Calculate the moving average of sales for each product over time, including only the next order.
SELECT
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	AVG(Sales) OVER (PARTITION BY ProductID) AvgByProduct,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) MovingAvg,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAvg
FROM Sales.Orders

-- Note - Over time analysis means sorting dates in ascending order