--Create Database
create database sql_project_p1;

--Now i am using the created Database for our project
use sql_project_p1;

--Now i am going to craete Table
drop table if exists retail_sales;
create table retail_sales
(
	transactions_id	int primary key,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(15),
	age int,
	category varchar(15),
	quantity int,
	price_per_unit float,	
	cogs float,
	total_sale float
);	

INSERT INTO retail_sales (transactions_id, sale_date, sale_time, customer_id, gender, age, category, quantity, price_per_unit, cogs,total_sale)
SELECT transactions_id, sale_date, sale_time, customer_id, gender, age, category, quantiy, price_per_unit, cogs,total_sale FROM RetailSalesAnalysis_utf;

select * from retail_sales;

select count(*) from retail_sales; --To identify whether we have imported a correct data or not

select count(distinct customer_id) as count from retail_sales; --Out of 2000 customer id there are only 155 individual counts 

--Here we are doing data cleaning(removing null/0 values)  
select * from retail_sales
where 
	transactions_id = 0 
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id = 0
	or
	gender is null
	or 
	age = 0
	or
	category is null
	or
	quantity = 0
	or 
	price_per_unit = 0
	or
	cogs = 0
	or 
	total_sale = 0;

delete from retail_sales 
where 
	transactions_id = 0 
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id = 0
	or
	gender is null
	or 
	age = 0
	or
	category is null
	or
	quantity = 0
	or 
	price_per_unit = 0
	or
	cogs = 0
	or 
	total_sale = 0;

--Data Exploration(EDA)
select * from retail_sales;

--How many sale we have?
select count(*) as total_sales from retail_sales;

--How many unique customers we have?
select count(customer_id) from retail_sales;
select count(distinct customer_id) as uniq_cust from retail_sales;

--how many unique categories we have?
select count(distinct category) as uniq_cust from retail_sales;
select distinct category from retail_sales;

--Solving business problems(qstn n ans)
--Wqtd all the columns for sales made on '2022-11-05'?
select * from retail_sales where sale_date = '2022-11-05';

--Wqtd all transactions where the category is clothing and quantity sold is more than 4 in the month of nov-2022?
select * from retail_sales where category = 'Clothing' and quantity >=4 and sale_date between '2022-11-01' and '2022-11-30' order by sale_date asc; 

--Wqtd total sales for each category?
select category, sum(total_sale) as net_sale from retail_sales group by category;

--Wqtd average age of customers who purchased items from the Beauty category?
select avg(age) as avg_age from retail_sales where category = 'Beauty';

--Wqtd all the transactions where the total sale is greater than 1000?
select * from retail_sales where total_sale > '1000';

--Wqtd total number of transactions(id) made by each gender in each category?
select category, gender, count(*) as tot_transactions from retail_sales group by gender, category order by category;

--Wqtd average sale for each month. Find out best selling month in each year.
SELECT * FROM (
    SELECT 
        YEAR(sale_date) AS year, 
        MONTH(sale_date) AS month, 
        ROUND(AVG(total_sale), 2) AS avg_sale,
        RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY ROUND(AVG(total_sale), 2) DESC) AS ranks
    FROM retail_sales 
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE ranks = 1;

--2nd approach
WITH MonthlySales AS (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        ROUND(AVG(total_sale), 2) AS avg_sale
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)

SELECT * FROM (
    SELECT 
        year,
        month,
        avg_sale,
        RANK() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS ranks
    FROM MonthlySales
) AS t1
WHERE ranks = 1;

--Wqtd the top 5 customers based on the highest total sales?
select top 5 customer_id, sum(total_sale) as total_sales from retail_sales group by customer_id order by total_sales desc; 

--Wqtd number of unique customers who purchased items for each category?
select category, count(distinct customer_id) as uniq_cust from retail_sales group by category;

--Wqtd to create each shift and number of orders (example morning <12, aftrnoon btwn 12 & 17, evening > 17)?
select * from retail_sales;

with hourly_sales
as
(
select *,
	case 
		when datepart(hour, sale_time) < 12 then 'morning'
		when datepart(hour, sale_time) between 12 and 17 then 'afternoon'
	else 'evening'
	end as shift
from retail_sales
)
select shift, count(*) as total_order from hourly_sales group by shift;

-----------------------------------------------------------------------------------














