--SQL Retail Sales Analysis P1
CREATE DATABASE sql_project_1


--CREATE TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
	);
--DATA CLEANING
select * from retail_sales
select count(*) from retail_sales
--
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR 
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
--
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR 
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
	
--DATA EXPLORATION

--HOW MANY SALES DO WE HAVE?
SELECT COUNT(*) as TOTAL_SALES FROM retail_sales;
--HOW MANY UNIQUE CUSTOMERS DO WE HAVE?
SELECT COUNT(DISTINCT(customer_id)) as TOTAL_CUSTOMERS FROM retail_sales
--HOW MANY UNIQUE CATEGORIS DO WE HAVE?
SELECT DISTINCT(category) as CATEGORIES FROM retail_sales

--Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL quely to retrieve all columns for sales made on '2022-11-05'.
--Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in
--the month of Nov-2022
--Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
--Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
--Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
--Q. 10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL quely to retrieve all columns for sales made on '2022-11-05'.
SELECT * FROM retail_sales 
WHERE sale_date='2022-11-05'

--Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in
--the month of Nov-2022
SELECT * FROM retail_sales
WHERE category='Clothing' and quantiy>=3 and
TO_CHAR(sale_date,'YYYY-MM')='2022-11'

----Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT SUM(total_sale) as TOTAL_SALES,category,COUNT(*) as TOTAL_ORDERS FROM retail_sales
GROUP BY category

--Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT ROUND(AVG(age),2) as average_age,category FROM retail_sales
WHERE category='Beauty'
GROUP BY category

--Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale>1000

--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select * from retail_sales
SELECT COUNT(transactions_id) as TOTAL_TRANSACTIONS,gender,category FROM retail_sales
GROUP BY gender,category

--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM
(
SELECT EXTRACT(YEAR FROM sale_date) AS YEAR,
	   EXTRACT(MONTH FROM sale_date) AS MONTH,
	   AVG(total_sale) AS AVG_TOT_SALE,
	   RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS RANK
FROM retail_sales
GROUP BY YEAR,MONTH
)
WHERE RANK=1
--ORDER BY YEAR,AVG_TOT_SALE DESC

--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id,SUM(total_sale) as TOTAL_SALES FROM retail_sales
GROUP BY customer_id
ORDER BY TOTAL_SALES DESC
LIMIT 5

--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT COUNT(DISTINCT(customer_id)),category FROM retail_sales
GROUP BY category

--Q. 10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_Sale
AS
(
SELECT *,
	   CASE
	   		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
	   END AS SHIFT
FROM retail_sales
)
SELECT COUNT(*) AS TOTAL_ORDERS,SHIFT FROM hourly_sale
GROUP BY SHIFT

--END OF PROJECT