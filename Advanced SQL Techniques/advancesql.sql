-- DATA WAREHOUSE
-- A special database that collects and integrates data
-- from different sources to enable analytics and support decision-making.

-- Challenges
-- Redundancy
-- If we don't optimze we will have Performance Issues
-- Complexity
-- Hard to Maintain
-- DB Stress - keeping executed big complex queries can make big stress for DB and it's going to bring database down
-- Security

-- Solutions
-- Subquery
-- CTE - Common Table Expression
-- Views
-- Temp Tables
-- CTAS - Create Table as Select

-- DB Architecture - Simplified
-- We have Server and Client
-- Client
-- Individuals like us writing query for specific purpose

-- Sever
-- Server is where DB lives and it has many components like
-- #1 DB Engine
-- It is the brain of the database, executing multiple operations such as 
-- storing, retrieving, and managing data within the databse.	
-- so each time we are going to execute query the DB Engine is going to take care of it


-- #2 Database Storage
-- DISK Storage
-- Long-term memory, where data is stored permamnently.
-- +Capacity: can hold a large amount of data.
-- -Speed: slow to read and to write

-- DISK storage has 3 types of storage areas
-- USER, SYSTEM CATALOGUE, TEMPERORARY
-- USER DATA STORAGE - It's the main content of the database.
-- This is where the actual data that users care about is stored.
-- Sales.Employess, Sales.Customers etc.

-- System Catalog - Database's internal storage for it's own information.
-- A blueprint that keeps track of everything about the database itself, not the user data.
-- It holds the Metadata information about the database.
-- METADATA - Data about Data
-- meta data can be found inside information schema
-- Information Schema - A system- defined schema with built-in views
-- that provide info about the database, like tables and columns.

SELECT
*
FROM INFORMATION_SCHEMA.COLUMNS
 

-- Temporary Storage - Temporary space used by the database for short-term tasks, like processing queries or sorting data.
-- Once these tasks are done, the storage is cleared.
-- In System Databse- tempdb - In real world we comapnies don't provide access to this.




-- CACHE Storage
-- Fast short-term memory, where data is stored temporarliy.
-- +Speed : extreme fast to read and to write
-- -Capacity: can hold smaller amount of data.



