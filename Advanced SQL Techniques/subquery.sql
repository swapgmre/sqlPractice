-- SUBQUERY
-- A Query Inside Another Query

-- When to use ?
-- WHY SUNQUERIES ?

-- Subquery Categories
-- Dependancy - If we are thinking about dependencies between the subquery and the main query
-- there are mainly two types of subqueries

-- #1 Non-Correlated Subquery
-- The subquery is independent from the main query

-- #2 Correlated Subquery
-- Subquery is dependent on the main query


-- Result Types - the subquery has different output results

-- #1 Scalar Subquery - It returns only one single value
-- #2 Row Subquery - It is going to return multiple rows
-- #3 Table Subquery - It returns multiple rows and multiple columns

-- Based on Location|Clauses - Where the subquery is going to be used within the main query
-- It can be used different location and clauses

-- SELECT , FROM(most common type for subquery), JOIN(before joining table) , WHERE(filter data in where clause)
-- In WHERE Clause there 2 different set of operators 
-- Comparison Operators or Logical Operators


-- Result Types
-- #1 Scalar Subquery - It is a subquery that is going to return only one single value.

SELECT
AVG(Sales)
FROM Sales.Orders

-- #2 Row Subquery - Subquery that is going to return Multiple Rows and Single Column
SELECT
CustomerID
FROM Sales.Orders

-- #3 Table Subquery - Returns Multiple Rows and Multiple Columns
SELECT
OrderID,
OrderDate
FROM Sales.Orders


-- Location|Clauses
-- Subquery in FROM Clause
-- Used as temporary table for the main query

/*
SELECT column1, column2, ...
FROM  (SELECT column FROM table1 WHERE condition) AS alias

The outer query is the main query
and the one inside the brackets is the subquery
*/


/* Task: Find the products that have a price
higher than the average price of all products
*/
-- Main query
SELECT
*
FROM(
-- Subquery
	SELECT
	ProductID,
	Price,
	AVG(Price) OVER() AvgPrice 
	FROM Sales.Products)t 
WHERE Price > AvgPrice

-- **TIP - To check the intermediate results of a subquery, highlight it and execute

-- Rank Customers based on their total amount of sales
SELECT *,
RANK() OVER	(ORDER BY TotalSales DESC) CustomerRank
FROM(
	SELECT
	CustomerID,
	SUM(Sales) TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID) t

-- SELECT Subquery
-- Used to aggregate data side by side with the main query's data, allowing for direct comparison.
/* 
Syntax of sub query in SELECT clause
SELECT
	Column1,
	(SELECT  column FROM table WHERE condition)
FROM table1

****Rules - Only Scalar Subqueries are allowed to be used i.e a single value
 
*/

-- Show the product IDs, product names, prices and total number of orders.

SELECT
ProductID,
Product,
Price,
		(SELECT 
	COUNT(*) FROM Sales.Orders) AS TotalOrders
FROM Sales.Products;

-- Subquery in JOIN clause
-- Used to prepare the data (filtering or aggregation) before joining it with other tables.
-- Show all customer details and find the total orders for each customer.

-- Main Query
SELECT
c.*,
o.TotalOrders
FROM Sales.Customers c
LEFT JOIN(
	SELECT
	CustomerID,
	COUNT(*) TotalOrders
	FROM Sales.Orders
	GROUP BY CustomerID) o
ON c.CustomerID = o.CustomerID

-- Subquery in WHERE Clause
-- Used for complex filtering logic and makes query more flexible and dynamic.
-- Comparison Operators
-- Used to filter data by comparing two values

/*
Syntax for Subquery in WHERE Clause Comparison Operators
SELECT column1, column2,...
FROM table1
WHERE column = (SELECT column FROM table2 WHERE condition)

*****Rules: Only Scalar Subqueries are allowed to be used
*/

-- Find the products that have a price higher than the average price of all products.

SELECT
ProductID,
Price,
(SELECT AVG(Price) FROM Sales.Products) AvgPrice
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products)

-- SubQuery IN Operator	
-- Check whether a value matches any value from a list.
/* Subquery in WHERE Clause IN Operator 

SELECT column1, column2, .....
FROM table1
WHERE column IN (SELECT column FROM table2 WHERE condition)

**** Can have list of multiple values in subquery

*/ 

-- Show the details of orders made by customers in Germany

SELECT 
*
FROM Sales.Orders
WHERE CustomerID IN 
	(SELECT
	CustomerID
	FROM Sales.Customers
	WHERE Country = 'Germany');

-- Show the details of orders for customers who are not from Germany 
SELECT 
*
FROM Sales.Orders
WHERE CustomerID IN 
	(SELECT
	CustomerID
	FROM Sales.Customers
	WHERE Country != 'Germany');

-- OR

SELECT 
*
FROM Sales.Orders
WHERE CustomerID NOT IN 
	(SELECT
	CustomerID
	FROM Sales.Customers
	WHERE Country = 'Germany');

-- Subquery ANY | ALL
-- ANY Operator - Checks if a value matches ANY value within a list.
-- Used to check if a value is true for AT LEAST one of the values in a list.

/* 
Subquery in WHERE clause ANY Operator

SELECT column1, column2, .....
FROM table1
WHERE column < ANY (SELECT column FROM table1 WHERE condition

-- Find female employees whose salaries are greater
-- than the salaries of any male employees

*/


SELECT
	EmployeeID,
	FirstName,
	Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ANY (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')

SELECT Salary FROM Sales.Employees WHERE Gender = 'M'

-- ALL Operator
-- Checks if a value matches ALL values within a list.

-- Find female employees whose salaries are greater
-- than the salaries of all male employees

SELECT
	EmployeeID,
	FirstName,
	Salary
FROM Sales.Employees
WHERE Gender = 'F'
AND Salary > ALL (SELECT Salary FROM Sales.Employees WHERE Gender = 'M')

SELECT Salary FROM Sales.Employees WHERE Gender = 'M'

-- Non- Correlated | Correlated Subqueries
-- Non- Correlated
-- A subquery that can run independtly from the Main Query

-- Correlated Subquery
-- A Subquery that relays on values from the Main Query

-- Show all customer details and find the total orders for each customer.

SELECT
*,
(SELECT COUNT(*) FROM Sales.Orders o WHERE o.CustomerID = c.CustomerID) TotalSales
FROM Sales.Customers c


-- Correlated Subquery
-- EXISTS
-- Check if a subquery returns any rows(results)

/*
Snytax Correlated Subquery in WHERE Clause EXISTS Operator

SELECT column1, column2, ...
FROM Table2
WHERE EXISTS (SELECT 1
			  FROM Table1 
			  WHERE Table1.ID = Table2.ID 
			 	  )

Like in comparison operator or IN Operator we don't specify columns befor EXISTS 
as we are not filtering based on value but we are filtering based on logic
*/


-- Show the details of orders made by customers in Germany.

SELECT
*
FROM Sales.Orders o
WHERE EXISTS (SELECT 1
		FROM Sales.Customers c
		WHERE Country = 'Germany'
		AND o.CustomerID = c.CustomerID);

SELECT
*
FROM Sales.Customers
WHERE Country = 'Germany'

-- Show the details of orders made by customers excluding Germany.

SELECT
*
FROM Sales.Orders o
WHERE NOT EXISTS (SELECT 1
		FROM Sales.Customers c
		WHERE Country = 'Germany'
		AND o.CustomerID = c.CustomerID);