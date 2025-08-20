-- Case Study 1: Top Selling Products
-- Question: What are the top 10 best-selling products by quantity?
-- Business Value: Helps identify products driving the highest demand.

select p.product_name,sum(o.quantity) as total_sold
from dim_product p inner join fact_orders o
on p.product_id = o.product_id 
group by p.product_name
order by total_sold DESC
limit 10;

-- Case Study 2: Revenue by Category
-- Question: Which product categories generate the most revenue? Rank them.
-- Business Value: Guides inventory and marketing focus.

-- Solution 1: Before discount/Promo code/Return
select p.category, sum(p.price*o.quantity) as gross_revenue 
from dim_product p inner join fact_orders o 
on p.product_id = o.product_id
group by p.category 
order by gross_revenue DESC;

-- Solution 2: After discount/Promo code/Return
select p.category,sum(o.final_price) as net_revenue
from dim_product p inner join fact_orders o
on p.product_id = o.product_id
group by p.category
order by net_revenue DESC;

-- Case Study 3: Monthly Revenue Trend
-- Question: Show monthly total revenue for the last 2 years.
-- Business Value: Reveals sales seasonality & growth trend.

-- Solution 1: Before discount/Promo code/Return
select date_format(d.date,'%Y-%m') as months,sum(p.price*o.quantity) as gross_revenue
from dim_date d inner join fact_orders o 
on d.date_id = o.date_id 
inner join dim_product p on p.product_id = o.product_id
where d.date>= date_sub((select max(date) from dim_date), interval 2 year)
group by months
order by months;

-- Solution 2: After discount/Promo code/Return
select date_format(d.date,'%Y-%m') as months, sum(o.final_price) as net_revenue
from dim_date d inner join fact_orders o 
on d.date_id = o.date_id
where d.date >= date_sub((select max(date) from dim_date), interval 2 year)
group by months
order by months;

-- Case Study 4: Customer Segmentation by Age Group
-- Question: Which age group contributes the most revenue?
-- Business Value: Helps design targeted promotions

-- Solution 1: Before discount/Promo code/Return
select 
	case 
		when c.age<20 then '<20'
        when c.age between 20 and 29 then '20-29'
        when c.age between 30 and 39 then '30-39'
        when c.age between 40 and 49 then '40-49'
        else '50+'
        end as age_group,
sum(p.price*o.quantity) as gross_revenue 
from dim_customer c inner join fact_orders o 
on c.customer_id = o.customer_id
inner join dim_product p on p.product_id = o.product_id 
group by age_group 
order by gross_revenue DESC;

-- Solution 2: After discount/Promo code/Return
select 
	case
		when c.age <20 then '<20'
        when c.age between 20 and 29 then '20-29'
        when c.age between 30 and 39 then '30-39'
        when c.age between 40 and 49 then '40-49'
        else '50+'
        end as age_group,
sum(o.final_price) as net_revenue from 
dim_customer c inner join fact_orders o
on c.customer_id = o.customer_id
group by age_group
order by net_revenue DESC;

-- Case Study 5: Impact of Discounts
-- Question: Compare average revenue per order with and without discounts.
-- Business Value: Evaluates effectiveness of discounts.

-- solution 1: Gross revenue per order
select round(avg(order_gross_revenue),2) as avg_gross_revenue_per_order from
(select o.order_id,sum(p.price*o.quantity) as order_gross_revenue 
from dim_product p inner join fact_orders o
on p.product_id = o.product_id
group by o.order_id) as der_tab;

-- Solution 2: After discount/Promo code/Return
select round(avg(order_net_revenue),2) as avg_net_revenue_per_order from
(select order_id,sum(final_price) as order_net_revenue
from  fact_orders
group by order_id) as der_tab;

-- Case Study 6: Payment Method Preference
-- Question: What are the most popular payment methods among customers?
-- Business Value: Optimize payment gateway and offers.

select p.method, count(o.order_id) as total_order 
from dim_payment p inner join fact_orders o
on p.payment_id = o.payment_id
group by method
order by total_order DESC
limit 1;

-- Case Study 7: Shipping Type Impact
-- Question: Do customers who choose Express shipping spend more than Standard shipping customers?
-- Business Value: Pricing & logistics strategy.

-- solution 1: average gross revenue per order for each shipping type.
select shipping_id,type, round(avg(order_total),2) as avg_gross_revenue_per_order from
(select o.order_id, s.shipping_id,s.type ,sum(p.price*o.quantity) as order_total
from dim_product p inner join fact_orders o 
on p.product_id = o.product_id 
inner join dim_shipping s on s.shipping_id = o.shipping_id
group by o.order_id,s.shipping_id,s.type
) as der_tab
group by shipping_id , type
order by avg_gross_revenue_per_order DESC;

-- solution 2: average net revenue per order for each shipping type.
select shipping_id, type, round(avg(order_total),2) as avg_net_revenue_per_order from
(select o.order_id, s.shipping_id, s.type, sum(o.final_price) as order_total
from dim_shipping s inner join fact_orders o 
on s.shipping_id = o.shipping_id
group by o.order_id,s.shipping_id,s.type
) as der_table
group by shipping_id, type
order by avg_net_revenue_per_order DESC;

-- Case Study 8: Customer Loyalty
-- Question: Who are the top 5 customers with the highest number of orders?
-- Business Value: Identify loyal customers for retention campaigns.

select customer_id,count(order_id) as total_orders
from fact_orders
group by customer_id
order by total_orders DESC
limit 5;

-- Case Study 9: Product Return Analysis
-- Question: What percentage of orders are returned, and which category has the highest return rate?
-- Business Value: Helps address quality/satisfaction issues.

-- Step 1: Percentage of Orders Returned
-- We check how many orders are flagged as returned (return_flag = 1) out of total orders.
select round(100.0*sum(case when return_flag = 1 then 1 else 0 end) / count(*),2) 
as return_percentage
from fact_orders;

-- Step 2: Category with Highest Return Rate
-- We join with dim_product to analyze return rate by category.

select p.category, round(100.0*sum(case when o.return_flag = 1 then 1 else 0 end) / count(*),2)
as return_percentage
from fact_orders o inner join dim_product p
on o.product_id = p.product_id
group by  p.category
order by return_percentage DESC;

-- Case Study 10: Promotion Effectiveness
-- Question: Compare average revenue per order where a promo code was used vs. not used.
-- Business Value: Understand if promo codes drive higher sales.

-- solution 1: Promotion Effectiveness(Gross Revenue)
-- 0 = no promo code used , 1 = with promo code used
select promo_code_used, round(avg(order_gross_revenue),2) as avg_gross_revenue_per_order from
(select o.order_id,o.promo_code_used,sum(p.price*o.quantity) as order_gross_revenue
from fact_orders o inner join dim_product p
on o.product_id = p.product_id
group by o.order_id, o.promo_code_used) as der_tab
group by promo_code_used;

-- solution 2: Promotion Effectiveness(Net Revenue)
-- 0 = no promo code used , 1 = with promo code used
select promo_code_used, round(avg(order_net_revenue),2) as avg_net_revenue_per_order from
(select order_id,promo_code_used,sum(final_price) as order_net_revenue
from fact_orders
group by order_id, promo_code_used) as der_tab
group by promo_code_used;


