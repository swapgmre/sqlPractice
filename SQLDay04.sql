-- DAY 04

-- FUNCTIONS
-- A built in SQL code:
	-- accepts an input value
	-- processes it
	-- returns an output value

-- FUNCTIONS can be categorized into two different categories
-- #1 Single Row Functions
-- We give input as one single row value and return an output as one single rpw value

-- #2 Multi-Row Functions
-- We give input as multiple values and return out as single values


-- NESTED Functions
-- Funtions used inside another function
-- Order of functions starts from inner most to the outer most functions

-- TYPES OF SQL FUNCTIONS
-- SINGLE ROW FUNCTIONS - ROW LEVEL CALCULATIONS
	-- FUnctions for STRINGS, NUMERIC, DATE & TIME, NULL

-- MULTI ROW FUNCTIONS - Aggregations
	-- Aggregate Functions - Basics
	-- WINDOW Functions - Advanced - also called analtical functions

-- STRING Functions
  /* 
  Manipulation -
  CONCAT, UPPER, LOWER, TRIM, REPLACE
  
  CALCULATION - 
  LEN

  String Extraction-
  LEFT, RIGHT, SUBSTRING
  */

  -- CONCAT
  -- Combine multiple strings into one

 -- Concatenate first name and country into one column

 SELECT 
	first_name,
	country,
	CONCAT(first_name,'-' , country) AS name_country,
	LOWER (first_name) AS low_name,
	UPPER (first_name) AS upper_name
	FROM customers

-- UPPER AND LOWER
-- UPPER - Converts all characters to uppercase
-- LOWER - Converts all characters to lowercase

-- check above example


-- TRIM - Removes leading and trailing spaces

-- Find customers whose first_name contains leading or trailing spaces

SELECT
	first_name,
	LEN(first_name) len_name,
	LEN(TRIM(first_name)) len_trim_name,
	LEN(first_name) - LEN(TRIM(first_name)) flag
FROM customers
WHERE LEN(first_name) != LEN(TRIM(first_name))
-- WHERE first_name != TRIM(first_name)

-- REPLACE - Replaces specific character with a new character
-- Also used to remove charaters (we have to replace it with blank)

SELECT
'123-456-7890' AS phone,
REPLACE('123-456-7890', '-', '') AS clean_phone

-- another usecase of Replace is to Replace File Extension from txt to csv

SELECT
'report.txt' AS old_filename,
REPLACE('report.txt', '.txt', '.csv') AS new_filename

-- LEN
-- Counts how many character

-- Calculate the length of each customer's first name

SELECT
	first_name,
	LEN(first_name) AS len_firstname
FROM customers

-- LEFT and RIGHT
-- LEFT - Extracts specific Number of characters from the start
-- RIGHT - EXtracts specific Number of Characters from the End
-- LEFT(Value, No. of Characters) , RIGHT(Value, No. of Characters)

-- Retrieve the first two characters of each first name

SELECT
	first_name,
	LEFT(first_name, 2) AS first_2_extract
FROM customers

-- Retrieve the last two characters of each first name

SELECT
	first_name,
	RIGHT(first_name, 2) AS first_2_extract
FROM customers


-- SUBSTRING - Extracts a part  of string at a specified position
-- SUBSTRING(Value, Start, Length)
-- for characters we want to remove all after start then we use third argument as LEN()

-- Retrieve a list of customer's first names after removing the first character

SELECT
	first_name,
	SUBSTRING(TRIM(first_name), 2, LEN(first_name)) AS sub_name
	FROM customers

-- NUMBER FUNCTIONS
-- ROUND

SELECT
	3.516,
	ROUND(3.516,2) AS round_2,
	ROUND(3.516,1) AS round_1,
	ROUND(3.516,0) AS round_0

-- ABS - returns the absolute (positive) value of a number, removing any negative sign.
SELECT
	-10,
	ABS(-10),
	ABS(10)


-- DATE & TIME FUNCTIONS called DATETIME FUNCTION in SERVER and TimeStamp in Oraclea and Psotgres

SELECT
	OrderID,
	OrderDate,
	ShipDate,
	CreationTime
FROM Sales.Orders

-- VALUES
-- In SQL we have three different sources in order to query the dates
-- #1 Date Column From a Table - i.e dates that are stored in our database
-- #2 Hardcoded Constant String Value
-- #3 GETDATE() Function - Returns the current date and time at the moment when the query is executed.

SELECT
	OrderID,
	CreationTime,
	'2025-08-20' HardCoded,
	GETDATE() Today
FROM Sales.Orders

-- DATE & TIME FUNCTION OVERVIEW
-- Manipulating information using SQL function
-- Extract different parts of date ex year, month, date
-- Change date format
-- Date calucations - Add dates or difference in dates
-- Validate date to check if SQL understands

-- Date % Time functions
/* 
--PART EXTRACTION
DAY
MONTH
YEAR
DATEPART
DATENAME
DATETRUNC
EOMONTH

-- FORMAT & CASTING
FORMAT
CONVERT
CAST

-- CALCULATIONS
DATEADD
DATEDIFF

-- VALIDATION
ISDATE

*/

-- DAY() - returns the day from a date
-- DAY(date)

-- MONTH() - returns the month from a date
-- MONTH(date)

-- YEAR() - returns the year from a date
-- YEAR(date)

SELECT
	OrderID,
	CreationTime,
	YEAR(CreationTime) Year,
	MONTH(CreationTime) month,
	DAY(CreationTime) day
FROM Sales.Orders

-- DATEPART() - Retunrs a specific part of a date as a number.
-- DATEPART(part, date)
-- Examples DATEPART(month, OrderDate)
-- Instead of writing month we can write mm

-- DATEPART returns Integer and DATENAME returns String

SELECT
	OrderID,
	CreationTime,
	-- DATETRUNC
	DATETRUNC(minute, CreationTime)	Minute_dt,
	DATETRUNC(year, CreationTime)	Year_dt,
	DATETRUNC(day, CreationTime)	Day_dt,
	-- DATENAME 
	DATENAME(month, CreationTime) Month_dn,
	DATENAME(weekday, CreationTime) weekday_dn,
	DATENAME(day, CreationTime) day_dn,
	--DATEPART
	DATEPART(year, CreationTime) year_dp,
	DATEPART(month, CreationTime) month_dp,
	DATEPART(day, CreationTime) day_dp,
	DATEPART(hour, CreationTime) hour_dp,
	DATEPART(quarter, CreationTime) quarter_dp,
	DATEPART(WEEKDAY, CreationTime) weekday_dp,
	DATEPART(week, CreationTime) week_dp,
	YEAR(CreationTime) Year,
	MONTH(CreationTime) month,
	DAY(CreationTime) day
FROM Sales.Orders

-- DATETRUNC()
-- Truncates the date to the specific part
-- DATETRUNC(part, date)

-- WHY DATETRUNC is important function for data analysis ?

SELECT
DATETRUNC(year, CreationTime) Creation,
COUNT(*)
FROM Sales.Orders
GROUP BY DATETRUNC(year, CreationTime)

-- EOMONTH() - Returns the last day of a month
-- EOMONTH(date)

SELECT
	OrderID,
	CreationTime,
	EOMONTH(CreationTime) EndofMonth,
	CAST(DATETRUNC(month, CreationTime) AS DATE ) StartofMonth
FROM Sales.Orders

-- Data Aggregations
-- How many orders were placed each year ?
SELECT
	YEAR(OrderDate),
	COUNT(*) NrOfOrders
FROM Sales.Orders
GROUP BY YEAR(OrderDate)

-- How many orders were placed each month ?
SELECT
	DATENAME(month, OrderDate) AS OrderDate,
	COUNT(*) NrOfOrders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate)

-- Data Filtering
-- Show all orders that were placed during the month of february
SELECT *
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2

-- **Best Practice - Filtering Data using an Integer is faster than using a Striing
-- Avoid Using DATENAME for filtering data, instead use DATEPART

-- Functions Comparison
-- DAY, MONTH, YEAR, DATEPART - Data type will be INT
-- DATENAME - data type will be STRING
-- DATETRUNC data type DATETIME
-- EOMONTH data type DATE

-- When to use which function?
-- Which Part to extract ?
-- If DAY, MONTH - Do i need it as an integer(NUMERIC)
-- Then we use DAY() MONTH()

-- But if we need full name of the month or day
-- DATENAME()

-- If we are interested with part year ? then we go with the YEAR()

-- If we don't need day, month or year and are interested like the week quarter and so on then we go with DATEPART()
-- REFER DIAGRAM

-- PART  EXTRACTION
-- ALL PARTS

-- FORMAT & CASTING
-- FORMAT
-- CONVERT
-- CAST

-- What is DATE FORMAT ?
-- YYYY - for year
-- MM - for month
-- dd - for day
-- HH - for hour
-- mm - for month
-- ss - second

-- SQL follows international standard (ISO 8601)
-- YYYY-MM-dd

-- USA Standard
-- MM -dd-YYYY

-- European Standard
-- dd-MM-YYYY

-- What is FORMATING & CASTING
-- FORMATING - Changing the format of a value from one to another.
-- Changing how the data looks like

-- CASTING & CONVERT
-- Changing the data type from one to another.


-- FORMAT() - Formats a date or time value
-- FORMAT(value, format [,culture])

SELECT
OrderID,
CreationTime,
FORMAT(CreationTime, 'MM-dd-yyyy') USA_format,
FORMAT(CreationTime, 'dd-MM-yyyy') EURO_format,
FORMAT(CreationTime, 'dd') dd,
FORMAT(CreationTime, 'ddd') ddd,
FORMAT(CreationTime, 'dddd') dddd,
FORMAT(CreationTime, 'MM') MM,
FORMAT(CreationTime, 'MMM') MMM,
FORMAT(CreationTime, 'MMMM') MMMM
FROM Sales.Orders	 

-- Show CreationTime using the following format:
-- Day Wed Jan Q1 2025 12:34:56 PM

SELECT
	OrderID,
	CreationTime,
	'Day ' + FORMAT(CreationTime,'ddd MMM') + 
	' Q'+ DATENAME(quarter, CreationTime) + ' ' +
	FORMAT(CreationTime, 'yyyy hh:mm:ss tt') AS CustomFormat
FROM Sales.Orders

-- Formatting Use Case - Data Aggreagtions
-- Use Case 1:  Using it to format the date before doing aggregation

SELECT 
FORMAT(OrderDate, 'MMM yy') OrderDate,
COUNT(*)
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'MMM yy')

-- Use Case 2:Data Standardization

-- ALL FORMATS - look for tables

-- CONVERT - Converts a date or time value to a different data type & Formats the value.
-- CONVERT (data_type, value [,style])

SELECT
CONVERT(INT, '123') AS [String to Int Comvert],
CONVERT(DATE, '2025-08-20') AS [String to Date Comvert],
CreationTime,
CONVERT(DATE, CreationTime) AS	[Datetime to Date CONVERT],
CONVERT(VARCHAR, CreationTime, 32) AS [USA std. Style:32 ],
CONVERT(VARCHAR, CreationTime, 34) AS [EURO std. Style:34]
FROM Sales.Orders

-- FOR STYLES REFER TO TABLES

-- CAST() - Converts a value to a specified data type
-- CAST (value AS data_type) 
-- CAST('123' AS INT)
-- CAST('2025-08-20' AS DATE)
-- ** No format can be soecified

SELECT
CAST('123' AS INT) AS [String to INT],
CAST( 123 AS VARCHAR) AS [INT to String],
CAST('2025-08-20' AS DATE) AS [String to DATE],
CAST('2025-08-20' AS DATETIME2) AS [String to DATETIME],
CreationTime,
CAST(CreationTime AS DATE) AS [Datetime tp Date]
FROM Sales.Orders

-- Date Calculations or Mathematical Operations on date
-- DATEADD
-- DATEDIFF

-- DATEADD 
-- Adds or substracts a specific time interval to/from a date.
-- DATEADD(part, interval, date)
-- ex DATEADD(year, 2, OrderDate)
-- ex DATEADD(month, -4, OrderDate)

SELECT
OrderID,
OrderDate,
DATEADD(day, -10, OrderDate) AS TenDaysBefore,
DATEADD(month, 3, OrderDate) AS ThreeMonthsLater,
DATEADD(year, 2, OrderDate) AS TwoYearsLater
FROM Sales.Orders


-- DATEDIFF()
-- Find the difference between two dates.
-- DATEDIFF(part, start_date, end_date)
-- ex DATEDIFF(year, OrderDate, ShipDate)
-- ex DATEDIFF(day, OrderDate, ShipDate)

-- Calculate the age of employees
SELECT
EmployeeID,
BirthDate,
DATEDIFF(year, BirthDate, GETDATE()) Age
FROM Sales.Employees

-- Find the average shipping duration in days for each month
SELECT 
	MONTH(OrderDate) AS OrderDate,
	AVG(DATEDIFF(day, OrderDate, ShipDate)) AS AvgShip
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

-- Time Gap Analysis
-- Find the number of days between each order and the previous order
-- Hint: LAG Access a value from the previous row
SELECT
OrderID,
OrderDate CurrentOrderDate,
LAG(OrderDate) OVER (ORDER BY OrderDate) PreviousOrderDate,
DATEDIFF(day, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate) NrOfDays
FROM Sales.Orders

-- Validation
-- ISDATE()
-- Checks if a value is a date.
-- Returns 1 if the string value is a valid date,
-- Or returns 0 if it is not a valid date
-- ISDATE(value)
-- ISDATE('2025-08-20')
-- ISDATE(2025)

SELECT
ISDATE('123') DateCheck1,
ISDATE('2025-08-20') DateCheck2,
ISDATE('20-08-2025') DateCheck3,
ISDATE('2025') DateCheck4,
ISDATE('08') DateCheck5


SELECT
--CAST(OrderDate AS DATE) OrderDate,
OrderDate,
ISDATE(OrderDate),
CASE WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
	ELSE '9999-01-01'
END NewOrderDate
FROM
(
	SELECT '2025-08-20' AS OrderDate UNION
	SELECT '2025-08-21' UNION
	SELECT '2025-08-23' UNION
	SELECT '2025-08'
) t
-- WHERE ISDATE(OrderDate) = 0


-- NULL vs Empty String vs Blank Space
-- NULL - means nothing, unknown
-- Empty String - String value has zero characters
-- Blank Space - String value has one or more space characters

WITH Orders AS (
SELECT 1 Id, 'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, '  '
)
SELECT
*,
DATALENGTH (Category) CategoryLen
FROM Orders

-- HANDLING NULLS
-- DATA POLICIES - Set of rules that defines how data should be handled.
-- We can define it like below
-- Only use NULLs and empty strings, but avoid blank spaces.

WITH Orders AS (
SELECT 1 Id, 'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, '  '
)
SELECT
*,
TRIM(Category) Policy1
FROM Orders

-- Check with DATALENGTH if it has removed the spaces
-- TRIM - remove unwanted leading and trailing spaces from a string

-- Option 2
-- Only use NULLS and avoid using empty string and blank spaces

WITH Orders AS (
SELECT 1 Id, 'A' Category UNION
SELECT 2, NULL UNION
SELECT 3, '' UNION
SELECT 4, '  '
)
SELECT
*,
TRIM(Category) Policy1,
NULLIF(TRIM(Category), '') Policy2,
COALESCE(NULLIF(TRIM(Category), ''), 'unknown') Policy3
FROM Orders

-- Option 3 
-- Use the default value 'unknown' and avoid using nulls, empty strings, and blank spaces.

-- When to use which options

-- Option 2
-- Replacing empty strings and blanks with NULL during data preparation
-- before inserting	into a database to optimize storage and performance.

-- Option 3
-- Replacing empty strings, blanks, NULL with default value
-- during data preparation before using it in reporting to 
-- improve readiblity and reduce confusion

-- NULL Functions Summary
-- Nulls are special markers means missing value
-- Using Nulls can optimize storage and performance

-- Use Cases
-- Handle Nulls - Data Aggregation
-- Handle Nulls - Mathematical Operations
-- Handle Nulls - Joining Tables
-- Handle Nulls - Sorting Data
-- Finding unmatched dataa - Left Anti Join
-- Data Policies - Nulls and Default Value