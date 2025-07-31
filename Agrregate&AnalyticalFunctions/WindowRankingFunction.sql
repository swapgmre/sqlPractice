-- RANKING WINDOW FUNCTION
-- INTEGER BASED RANKING - Discrete Distinct Values
-- When to use ? Find top 3 products, here we are not interested in contrubutions of each products to overall total
-- We are interested in the position of the value within a list
-- Commonly used in reporting
-- Top/Bottom N Analysis

-- ROW_NUMBER, RANK, DENSE_RANK, NTILE()

-- PERCENTAGE BASED RANKING - (0 to 1) - Continuous Values
-- When to use ? - ex. Find top 20% products based on their sales
-- Called Distribution Analysis
-- CUME_DIST, PERCENT_RANK


/* 
Syntax

RANK() OVER(PARTITION BY ProductID ORDER BY SALES)

- Rule 1 : In RANK agrumnet expression must be empty
- Rule 2: PARTITION BY is Optional
- Rule 3 : Order By is required

** only NTILE(n) can accept an INTEGER or Number as argument
** Frame Clause is not allowed to use inside RANK functions

*/


-- ROW_NUMBER
-- Assign a unique number to each row.
-- It doesn't handle ties.

-- Rank the orders based on their sales from highest to lowest

SELECT
OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER(ORDER BY Sales DESC) SaleRank_Row,
RANK() OVER(ORDER BY Sales DESC) SalesRank_Rank,
DENSE_RANK() OVER(ORDER BY Sales DESC) SalesDense_RANK
FROM Sales.Orders

-- RANK()
-- Assign a rank to each row.
-- It hanldes ties.
-- It leaves gaps in ranking.
-- Shared Ranking, leaving gaps(skipping)

-- DENSE_RANK()
-- Assign a rank to each row.
-- It handles ties.
-- It doesn't leaves gaps in ranking.
-- Shared Ranking, leaving no gaps (no skipping)

-- INTEGER BASED RANKING
-- COMPARISON between ROW_NUMBER, RANK and DENSE_RANK
-- ROW_NUMBER has unique distinct rank where as RANK and DENSE_RANK has shared rank or duplicates
-- Only function that don't handle ties is ROW_NUMBER()
-- NO Gaps or Skipping for ROW_NUMBER and DENSE_RANK whereas RANK has skipping or leaving gaps

-- ROW_NUMBER USE CASE
-- TOP-N ANALYSIS
-- Analysis the top performers to do targeted marketing

-- Find the top highest sales for each product


SELECT *
FROM
(SELECT
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY Sales DESC) RankByProduct
FROM Sales.Orders
)t WHERE RankByProduct = 1;


-- #2 USE CASE - BOTTOM-N ANALYSIS
-- Help analysis the underperformance to manage risks and to do	optimizations


-- Find the lowest 2 customers based on their total sales
-- Step 1 - Add GROUP BY to the query
-- Step 2 - Add WINDOW function to the query
-- **Rule - Columns used in GROUP BY and WINDOW function must be the same

SELECT *
FROM(
SELECT
	CustomerID,
	SUM(Sales) TotalSales,
	ROW_NUMBER() OVER(ORDER BY SUM(Sales))  RankCustomers
FROM Sales.Orders
GROUP BY 
CustomerID
) t WHERE RankCustomers <=2

-- #3 USE CASE - Generate Unique IDs or Assign Unique IDs
-- Help to assign unique identifier	for each row to help paginating
-- Paginating - The process of breaking down a large data into smaller, more manageable chunks


-- Assign unique IDs to the rows of the 'Orders Archieve' table

SELECT
ROW_NUMBER() OVER (ORDER BY OrderID, OrderDate) UniqueID,
*
FROM Sales.OrdersArchive

-- #4 USE CASE - IDENTIFY DUPLICATES
-- Identify and remove duplicate rows to improve data quality

-- Identify duplicate rows in the table 'OrdersArchieve' and
-- return a clean result without any duplicates

-- **Divide (partition) the data by the primary key of the table
-- If the rank exceeds 1, it indicates that the primary key is not unique

SELECT * FROM (
SELECT
ROW_NUMBER() OVER (PARTITION BY OrderID ORDER BY CreationTime DESC) rn,
*
FROM Sales.OrdersArchive
) t WHERE rn = 1

-- NTILE()
-- Divides the rows into a specified number of approximately equal groups(Buckets)
-- Bucket Size = Number of Rows / Number of Buckets
-- NTILE accpets an integer as argument and it is mandatory
-- If there are odd buckets size, them SQL rule states that Larger groups come first

SELECT
	OrderID,
	Sales,
	NTILE(4) OVER (ORDER BY Sales DESC) OneBucket,
	NTILE(3) OVER (ORDER BY Sales DESC) OneBucket,
	NTILE(2) OVER (ORDER BY Sales DESC) OneBucket,
	NTILE(1) OVER (ORDER BY Sales DESC) OneBucket
FROM Sales.Orders


-- NTILE USE CASE

-- Data Analyst - Data Segmentation
-- Data Engineer - ETL processing & Equalizing load processing

-- #1 USE CASE - DATA SEGMENTATION
-- Divides a dataset into distinct subsets based on certain criteria.

-- Segment all orders into 3 categories: high, medium and low sales.
SELECT
*,
CASE WHEN Buckets = 1 THEN 'High'
	 WHEN Buckets = 2 THEN 'Medium'
	 WHEN Buckets = 3 THEN 'Low'
END SalesSegmentations
FROM (
	SELECT
		OrderID,
		Sales,
		NTILE(3) OVER(ORDER BY Sales DESC) Buckets
	FROM Sales.Orders
)t

-- #2 USE CASE - Equalizing Load
-- In order to export the data, divide the orders into 2 groups.

SELECT
NTILE(4) OVER(ORDER BY OrderID) Buckets,
*
FROM Sales.Orders

-- PERCENTAGE-BASED RANKING
-- CUME_DIST
-- Formula - Position Nr/ Number of Rows

-- PRECENT_RANK
-- Formula - Position Nr - 1/ Number of Rows - 1

-- CUME_DIST()
-- Cumulative Distribution calculates the distribution of data points within a window
-- Tie Rule - The position of the last occurence of the same value

-- PERCENT_RANK()
-- Calculates the relative position of each row within a window
-- Tie Rule - The position of the first occurence of the same value

-- USE CASE
-- If we want to focus on the distribution of data points go with CUME_DIST()
-- IF we want to focus on relative position of each row then go with PERCENT_RANK

-- DIFFERENCE in CUME_DIST() vs. PERCENT_RANK()
-- Inclusive (The current row is included)
-- Exclusive (The current row is excluded)

-- Find the products that fall within the highest 40% of prices
SELECT
*,
CONCAT(DistRank * 100, '%') AS DistRankPercent
FROM(
SELECT
	Product,
	Price,
	CUME_DIST() OVER (ORDER BY Price DESC) DistRank
FROM Sales.Products
)t WHERE DistRank <= 0.4


SELECT
*,
CONCAT(DistRank * 100, '%') AS DistRankPercent
FROM(
SELECT
	Product,
	Price,
	PERCENT_RANK() OVER (ORDER BY Price DESC) DistRank
FROM Sales.Products
)t WHERE DistRank <= 0.4