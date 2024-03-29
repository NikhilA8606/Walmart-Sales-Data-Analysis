CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);



-- -------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------Feature Engineering-----------------------------------------------------------------------

-- time_of_day

select time,
	(case
		when `time` between "00:00:00" and "12:00:00" then "Morning"
        when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
	end
	) as time_of_date
from sales;

alter table sales add column time_of_day varchar(20);

update sales
set time_of_day = (case
		when `time` between "00:00:00" and "12:00:00" then "Morning"
        when `time` between "12:01:00" and "16:00:00" then "Afternoon"
        else "Evening"
	end
	);
    
-- day_name

select date,
	dayname(date) as day_name
    from sales;
    
alter table sales add column day_name varchar(20);

update sales 
set day_name = dayname(date);

-- month_name

select date,
	monthname(date) as month_name
    from sales;
    
alter table sales add column month_name varchar(20);

update sales 
set month_name = monthname(date);

-- --------------------------------------------------------------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------- Generic Questions --------------------------------------------------------------------

-- How many unique cities does the data have?

select count(distinct(city)) from sales;

-- In which city each is each branch

select distinct city,branch from sales;

-- -------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------- Product ------------------------------------------------------------------------------

-- How many unique product lines does the data have?
select count(distinct(product_line)) from sales;

-- What is the most common payment method?
select payment,count(payment) as cnt 
from sales
group by payment
order by cnt desc;

-- What is the most selling product line?
select product_line,count(product_line) as cnt
from sales 
group by product_line
order by cnt desc;

-- What is the total revenue by month?
select month_name,sum(total) as total_rev
from sales
group by month_name
order by total_rev desc;

-- What month had the largest COGS?
select month_name,sum(cogs) as total_cogs
from sales
group by month_name
order by total_cogs desc;

-- What product line had the largest revenue?
select product_line,sum(total) as large_revenue
from sales
group by product_line
order by large_revenue desc;

-- What is the city with the largest revenue?
select city,sum(total) as large_revenue
from sales
group by city
order by large_revenue desc;

-- What product line had the largest VAT?
select product_line,avg(VAT) as large_vat
from sales
group by product_line
order by large_vat desc;

-- Which branch sold more products than average product sold?
select branch,sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

-- What is the most common product line by gender?
select product_line,gender,count(gender) as cnt
from sales
group by gender,product_line
order by cnt desc;

-- What is the average rating of each product line?
select product_line,round(avg(rating),2) as avg_rate
from sales
group by product_line
order by avg_rate desc;

-- -------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------- Sales --------------------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday
select time_of_day,count(*) as total_sale
from sales
where day_name = "Sunday"
group by time_of_day
order by total_sale desc;

-- Which of the customer types brings the most revenue?
select customer_type,sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city,avg(VAT) as avg_vat
from sales
group by city
order by avg_vat desc;

-- Which customer type pays the most in VAT?
select customer_type,avg(VAT) as avg_vat
from sales
group by customer_type
order by avg_vat desc;

-- -------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------- Customer -----------------------------------------------------------------------------
-- How many unique customer types does the data have?
select distinct customer_type from sales;

-- How many unique payment methods does the data have?
select distinct payment from sales;

-- What is the most common customer type?
select customer_type, count(customer_type) as cnt
from sales
group by customer_type
order by cnt desc;

-- Which customer type buys the most?
select customer_type , count(*) as customer_cnt
from sales
group by customer_type;

-- What is the gender of most of the customers?
select gender,count(gender) as cnt
from sales
group by gender
order by cnt desc;

-- What is the gender distribution per branch?
select gender,count(gender) as cnt
from sales
where branch = "A"
group by gender
order by cnt desc;

-- Which time of the day do customers give most ratings?
select time_of_day, avg(rating) as cnt
from sales
group by time_of_day
order by cnt desc;

-- Which time of the day do customers give most ratings per branch?
select time_of_day, avg(rating) as cnt
from sales
where branch = "A"
group by time_of_day
order by cnt desc;

-- Which day fo the week has the best avg ratings?
select day_name,avg(rating) as cnt
from sales
group by day_name
order by cnt desc;

-- Which day of the week has the best average ratings per branch?
select day_name,avg(rating) as cnt
from sales
where branch = "A"
group by day_name
order by cnt desc;
-- -----------------------------------------------------------------------------------------------------------------------------------------
