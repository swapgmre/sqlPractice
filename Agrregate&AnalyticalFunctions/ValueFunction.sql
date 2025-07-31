-- VALUE WINDOW FUNCTION 
-- LEAD(expr, offset, default)
-- expr - all data type 
-- partiton clause - optional
-- order clause - required
-- frame clause - not allowed

-- LAG(expr, offset, default)
-- expr - all data type 
-- partiton clause - optional
-- order clause - required
-- frame clause - not allowed

-- FIRST_VALUE(expr)
-- expr - all data type 
-- partiton clause - optional
-- order clause - required
-- frame clause - Optional


-- LAST_VALUE(expr)
-- expr - all data type 
-- partiton clause - optional
-- order clause - required
-- frame clause - should be used

-- LEAD()
-- Access a value from the next row within a window.
-- Syntax
-- LEAD(Sales, 2, 10) OVER(PARTITION BY ProductID ORDER BY OrderDate)
-- for LEAD() we will always get the last value as NULL


-- LAG()
-- Access a value from the previous row within a window.
-- Syntax
-- LAG(Sales, 2, 10) OVER(PARTITION BY ProductID ORDER BY OrderDate)
-- for LAG() we will always get the start value as NULL

-- LEAD/LAG USE CASES
-- (MoM) Month-Over-Month Analysis

-- Time Series Analysis
-- The process of analyzing the data to understand patterns, trends, and behaviours over time.
-- Classical question asked by Business will be Year-over-Year(YoY) 
-- and Month-over-Month Analysis(MoM)

-- YoY - Analyze the overall growth or decline of the business's performance over time
-- MoM - Analyze short-term trends and discover patterns in seasonality

-- Analyze the month-over-month (MoM) performance by finding the
-- percentage change in sales between the current and previous month


SELECT
*,
CurrentMonthSales - PreviousMonthSales AS MoM_Change,
ROUND(CAST((CurrentMonthSales - PreviousMonthSales) AS FLOAT)/PreviousMonthSales * 100,1) AS MoMPercent_Change
FROM(
SELECT
	MONTH(OrderDate) OrderMonth,
	SUM(Sales) CurrentMonthSales,
	LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) PreviousMonthSales
FROM Sales.Orders
GROUP BY
	MONTH(OrderDate)
) t


-- #2 USE CASE - CUSTOMER RETENTION ANALYSIS
-- Measure customer's behavior and loyalty to help businesses build strong relationships with customers.

-- In order to analyze customer loyalty,
-- rank customers based on the average days between thier orders
SELECT
CustomerID,
AVG(DaysUntilNextOrder) AvgDays,
RANK() OVER (ORDER BY COALESCE(AVG(DaysUntilNextOrder), 99999))  RankAvg
FROM
(SELECT
	OrderID,
	CustomerID,
	OrderDate CurrentOrder,
	LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) NextOrder,
	DATEDIFF(day, OrderDate, LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)) DaysUntilNextOrder
FROM Sales.Orders
)t
GROUP BY 
	CustomerID


-- FIRST_VALUE()
-- Access a value from the first row within a window.
-- Default frame works


-- LAST_VALUE()
-- Access a value from the last row within a window
-- deault frame does not work

-- #1 USE CASE - Compare to Extremes
-- How well a value is performing relative to the extremes

-- Find the lowest and highest sales for each product
-- Find the difference in sales between the current and the lowest sales

SELECT
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) LowestSales,
	LAST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales,
	Sales - FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) AS SalesDifference
--	FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales DESC) HighestSales2,
--	MIN(Sales) OVER (PARTITION BY ProductID) MinLowestSales,
--	MAX(Sales) OVER (PARTITION BY ProductID) MaxHighestSales
FROM Sales.Orders

