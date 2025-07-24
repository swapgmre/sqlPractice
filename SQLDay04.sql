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