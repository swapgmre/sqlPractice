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
ROW_NUMBER() OVER(ORDER BY Sales DESC) SaleRank_Row
FROM Sales.Orders
