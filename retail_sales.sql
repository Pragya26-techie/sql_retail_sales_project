-- sql retail sales analysis
CREATE DATABASE retail_db;
USE retail_db;

-- create tablle
CREATE TABLE retail_sales
(transaction_id INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(50),
age INT,
category VARCHAR(50),
quantity  INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

SELECT * FROM retail_sales
LIMIT 10;

# verify total no of rows in record
select count(*) from retail_sales;
SELECT COUNT(*)
FROM retail_sales
WHERE age IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
SELECT COUNT(*) AS total_records
FROM retail_sales;

-- DATA CLEANING
# check null values
SELECT * FROM retail_sales
WHERE transaction_id IS NULL;

#one query to check for all column null value
SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

-- DATA EXPLORATION

-- How many sales do we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id ) FROM retail_sales;

-- How many categories we have?
SELECT DISTINCT category FROM retail_sales;

-- DATA ANALYSIS & Business key problems and answers

-- My analysis & Findings
-- Q.1 Write a SQL query to retieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- SELECT * FROM retail_sales
-- WHERE category='Clothing' AND DATE_FORMAT(sale_date,'%Y-%M') = '2022-11' AND quantity >= 4;

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  AND quantity >= 4; 

-- Q.3-Write a SQL query to calculate the total sales(total_sale) for each category.

SELECT sum(total_sale),category from retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purcahsed items from the 'Beauty' category.
SELECT AVG(age) FROM retail_sales
WHERE category = 'Beauty';

-- Q.5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q.6.Write a SQL query to find the toal_number of transactions(transaction_id) made by each gender in each category.
SELECT COUNT(*),category,gender FROM retail_sales
GROUP BY category,gender
ORDER BY category,gender; -- categorise data

-- Q.7.Write a SQL query to calculate the average sale fro each month.Find out best selling month in each year.SELECT * FROM
SELECT * FROM
(
  SELECT 
    AVG(total_sale) as avg_sale,YEAR(sale_date) as year,MONTH(sale_date) as month,
    RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as rnk
 FROM retail_sales
 GROUP BY year,month
) as t1
WHERE rnk = 1;
-- ORDER by year,avg_sale DESC

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id,sum(total_sale) FROM retail_sales
GROUP BY customer_id
ORDER BY sum(total_sale) DESC
LIMIT 5	;

-- Q.9 write a SQL query to find the number of unique customers who purchased items from each category.
SELECT COUNT(DISTINCT(customer_id)),category FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders(Example Morning <12,Aternoon Between 12 & 17,Evening > 17)
WITH hourly_sale
as
(
SELECT *,
CASE
    WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT shift,COUNT(*) as total_orders FROM hourly_sale
GROUP BY shift;






  






 
            