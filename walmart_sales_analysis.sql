select * from walmart.sales;

----#Feature Engineering---------------
----#1 Time of DAY --------------------
select time,
(case
	when time between "00:00:00" and "12:00:00" then "Morning"
	when time between "12:01:00" and "16:00:00" then "Afternoon"
	else "Evening" 
 end
 ) as time_of_date
from sales;

Alter table sales add column time_of_day varchar(20);

update sales
set time_of_day = (
case
	when time between "00:00:00" and "12:00:00" then "Morning"
	when time between "12:01:00" and "16:00:00" then "Afternoon"
	else "Evening" 
 end
);

---#2 Day_name------
select date, dayname(date) as day_name
from sales;

alter table sales add column day_name varchar(10)
update sales
set day_name = dayname(date);

-----#3 month_name----------

select date, monthname(date) as month_name
from sales;

alter table sales add column month_name varchar(10)
update sales
set month_name = monthname(date);

-------------------------------------------------------------------------------------

------#Business Questions--------------
---#1 How many unique does the data have ? ----------
select distinct city from sales; 

---#2 In which city is each branch -----
select distinct city,branch from sales; 

---------------------------------------------------------------------------------------

------#Product Analysis Questions--------------
---#1 How many unique product lines does the data have?-----
select count(distinct product_line) from sales;

---#2 What is the most common payment method? ----
select payment_method, count(payment_method) as count_payment_method from sales 
group by payment_method
order by count_payment_method desc;

---#3 What is the most selling product line? -----
select product_line, count(product_line) as cnt_pl from sales
group by product_line
order by cnt_pl desc;

---#4 What is the total revenue by month? ----
select month_name, sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

---#5 What month had the largest COGS(Cost of Goods Sold)? ----
select month_name, sum(cogs) as largest_cog
from sales
group by month_name
order by largest_cog desc;

---#6 What product line had the largest revenue? ----
select product_line, sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

---#7 What is the city with the largest revenue?---
select city, sum(total) as total_revenue
from sales
group by city
order by total_revenue desc;

---#8 What product line had the largest VAT(Value Added Tax)? ---
select product_line, avg(VAT) as total_VAT
from sales
group by product_line
order by total_VAT desc;

---#9 Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT product_line,
	(CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END ) as remark
FROM sales
GROUP BY product_line;

Alter table sales add column remarks varchar(20);
update sales
set remarks = (CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END 
);

---#10 Which branch sold more products than average product sold?---
select branch,sum(quantity) as qty
from sales
group by branch
having sum(quantity)>(select avg(quantity) from sales)
order by qty desc;

---#11 What is the most common product line by gender?---
select gender, product_line, count(gender) as total_cnt from sales
group by gender, product_line
order by total_cnt desc;

---#12 What is the average rating of each product line?---
select distinct product_line, avg(rating) as avg_rating
from sales
group by product_line
order by avg_rating desc;

--------------------------------------------------------------------------------------

------#Sales Analysis Questions--------------

---#1 Number of sales made in each time of the day per weekday-----
select time_of_day, count(*) as total_sales
from sales
where day_name="Sunday"
group by time_of_day
order by total_sales desc;

---#2 Which of the customer types brings the most revenue?----
select customer_type, sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue desc;

---#3 Which city has the largest tax percent/ VAT (Value Added Tax)?-----
select city, avg(VAT) as largest_tax_pct
from sales
group by city
order by largest_tax_pct desc limit 1;

---#4 Which customer type pays the most in VAT? ----
select customer_type, avg(VAT) as largest_tax_pct
from sales
group by customer_type
order by largest_tax_pct desc limit 1;

-----------------------------------------------------------------------------------

------#Customer Analysis Questions--------------

---#1 How many unique customer types does the data have?----
select distinct customer_type from sales;

---#2 How many unique payment methods does the data have?---
select distinct payment_method from sales;

---#3 What is the most common customer type?----
select customer_type,count(*) as cnt from sales
GROUP BY customer_type
ORDER BY cnt DESC;

---#4 Which customer type buys the most?-----
select customer_type, count(*) as cust_cnt
from sales
group by customer_type
order by cust_cnt desc;

--- #5 What is the gender of most of the customers?----
select gender, count(*) as gen_cnt
from sales
group by gender
order by gen_cnt desc;

---#6 What is the gender distribution per branch? -----
select branch, gender, count(gender) as cnt_per_branch
from sales
group by branch, gender
order by cnt_per_branch;

---#7 Which time of the day do customers give most ratings?---
select time_of_day, avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;

---#8 Which time of the day do customers give most ratings per branch?---
select branch, time_of_day, avg(rating) as avg_rating
from sales
where branch = "B"
group by time_of_day
order by avg_rating desc;

---#9 Which day of the week has the best avg ratings?---
select day_name, avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc limit 1;

---#10 Which day of the week has the best average ratings per branch?---
select day_name, branch, avg(rating) as avg_rating
from sales
where branch = "A"
group by day_name
order by avg_rating desc;


