-- CASE STATEMENT
-- Evaluates a list of conditions and returns a value when
-- the first condition is met

-- Syntax 
-- starts from top to bottom - most imp condition should be at start
/* 
CASE 
	WHEN condition1 THEN  result1
	WHEN condition2 THEN result2
	...
	ELSE result (optionall/used when all condition fails use this) 

END


** SQL execution stops once the first condition is met
*/


/* 
 USE CASE
 Main purpose of Case Statement is Data Transformation
 Drive new information
 - Create new Columns based on existing data
 #1 Categorizing Data
 Group the data into different categories based on certain conditions.
*/

-- Generate a report showing the total sales for each category:
 -- High: If the sales higher than 50
 -- Medium: If the sales between 20 and 50
 -- Low: If the sales equal or lower than 20
-- Sort the result from highest to lowest.

SELECT
Category,
SUM(Sales) AS TotalSales
FROM(SELECT
OrderID,
Sales,
CASE
	WHEN Sales > 50 THEN 'High'
	WHEN Sales > 20 THEN 'Medium'
	ELSE 'Lower'
END Category
FROM Sales.Orders
)t
GROUP BY Category
ORDER BY TotalSales DESC

-- CASE STATEMENTS
-- RULES 
-- The data type of the results must be matching, i.e. values after THEN and ELSE
-- CASE statement can be used anywhere in the query

-- #2 USE CASE
-- MAPPING VALUES - Transform the values from one form to another in order to make it more readable and more usable for analytics

-- Retrieve emloyee details with gender displayed as full text

SELECT
EmployeeID,
FirstName,
LastName,
Gender,
CASE
	WHEN Gender = 'F' THEN 'Female'
	WHEN Gender = 'M' THEN 'Male'
	ELSE 'Not Avilable'
END
FROM Sales.Employees

-- Retrieve customer details with abbreviated country code
SELECT
CustomerID,
FirstName,
LastName,
Country,
CASE 
	WHEN Country = 'Germany' THEN 'DE'
	WHEN Country = 'USA' THEN 'US'
	ELSE 'n/a'
END CountryAbbr,

CASE Country
	WHEN 'Germany' THEN 'DE'
	WHEN 'USA' THEN 'US'
	ELSE 'n/a'
END CountryAbbr2
FROM Sales.Customers;

SELECT DISTINCT Country
FROM Sales.Customers;

-- CASE STATEMENT
-- QUICK FORM - rmeber this works only if the column is same


-- #3 USE CASE
-- Handling Nulls - means Replace NULLs with a specific value.
-- NULLs can lead to inaccurate results, which can lead to wrong decision-making.

-- Find the average scores of customers and treats Nulls as 0
-- And Additionally provide details such as CustomerID & LastName

SELECT
CustomerID,
LastName,
Score,
CASE
	WHEN Score IS NULL THEN 0
	ELSE Score
END ScoreClean,
AVG(CASE
	WHEN Score IS NULL THEN 0
	ELSE Score
END) OVER() AvgCustomerClean,

AVG (Score) OVER() AvgCustomer
FROM Sales.Customers

-- #4 USE CASE
-- Conditional Aggregation
-- Apply aggregate functions only on subsets of data that fulfill certain conditions

-- Count how many times each customer has made an order
-- with sales greater than 30.
-- Hint: FLAG Binary indicator(1,0) to be summarize to show how many times the condition is true
--  STEP 1 - Create Flag with binary values(0,1) to mark rows that meet certain criteria.
-- STEP 2 - Summarize the binary flag

SELECT
CustomerID,
SUM(CASE
	WHEN Sales > 30 THEN 1
	ELSE 0
END) TotalOrdersHighSales,
COUNT(*) TotalOrders
FROM Sales.Orders
GROUP BY CustomerID