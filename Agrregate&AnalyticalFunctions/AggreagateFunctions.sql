-- Aggregate Functions - Used to cover insights from our data
-- Accept multiple rows as an input and output  usually is a single value

-- COUNT, SUM, AVG, MAX, MIN

-- Find the total number of orders
-- Find the total sales of all orders
-- Find the average sales of all orders
-- Find the highest sales among all the orders
-- Find the lowest sales among all the orders

SELECT
customer_id,
COUNT(*) AS Total_nr_orders,
SUM(sales) AS total_sales,
AVG(sales) AS Avg_Sales,
MAX(sales) AS highest_Sale,
MIN(sales) AS lowest_sale
FROM Orders
GROUP BY customer_id

-- Analyze the scores in customers table
SELECT
Country,
AVG(COALESCE(Score,0)) AS Avg_Score,
MAX(COALESCE(Score,0)) AS Highest_Score,
MIN(COALESCE(Score,0)) AS Lowest_Score
FROM Sales.Customers
GROUP BY Country


