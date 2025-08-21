# 🛒 Case Study 1: Top Selling Products

**📌 Question:**

**What are the top 10 best-selling products by quantity?**

🧾 SQL Query:
```sql
select p.product_name,sum(o.quantity) as total_sold
from dim_product p inner join fact_orders o
on p.product_id = o.product_id 
group by p.product_name
order by total_sold DESC
limit 10;
```
📊 Output:
| product_name | total_sold |
|--------------|------------|
| Sunglasses   | 43         |
| Laptop       | 38         |
| Smartwatch   | 36         |
| Jeans        | 32         |
| Vacuum       | 31         |
| Chair        | 30         |
| Headphones   | 30         |
| Jacket       | 26         |
| Shoes        | 26         |
| Belt         | 24         |

**💡 Insight:**

The top-selling product is Sunglasses (43 units), followed closely by Laptop (38 units) and Smartwatch (36 units). Interestingly, a mix of fashion (sunglasses, jeans, jacket, shoes, belt) and electronics (laptop, smartwatch, headphones, vacuum) dominate the list, showing balanced demand across categories.

**🏆 Business Value:**

This analysis helps the business identify its best-performing products. Such insights can guide inventory planning, promotional campaigns, and targeted marketing to maximize sales from high-demand items.

# 💰 Case Study 2: Revenue by Category

**📌 Question:**

**Which product categories generate the most revenue? Rank them.**

🧾 SQL Queries:

✅ Solution 1: Gross Revenue (Before Discounts/Promo/Returns)
```sql
select p.category, sum(p.price*o.quantity) as gross_revenue 
from dim_product p inner join fact_orders o 
on p.product_id = o.product_id
group by p.category 
order by gross_revenue DESC;
```
📊 Output (Gross Revenue):
| category    | gross_revenue |
|-------------|---------------|
| Home        | 37229.16      |
| Electronics | 27289.98      |
| Clothing    | 20445.82      |
| Accessories | 16971.75      |

✅ Solution 2: Net Revenue (After Discounts/Promo/Returns)
```sql
select p.category,sum(o.final_price) as net_revenue
from dim_product p inner join fact_orders o
on p.product_id = o.product_id
group by p.category
order by net_revenue DESC;
```
📊 Output (Net Revenue):
| category    | net_revenue |
|-------------|-------------|
| Home        | 33386.1     |
| Electronics | 24878.07    |
| Clothing    | 18073.61    |
| Accessories | 15398.75    |

**💡 Insight:**

Home category leads revenue generation both before and after discounts, contributing the highest share.

Electronics consistently ranks 2nd, followed by Clothing and Accessories.

After applying discounts/promo codes/returns, revenue decreases across all categories, with Home still retaining dominance.

The difference between gross and net revenue highlights the impact of discounts and promotions on total earnings.

**🏆 Business Value:**

Helps businesses identify top revenue-driving categories and allocate resources effectively.

By comparing gross vs. net revenue, businesses can evaluate whether promotions are eating into profits disproportionately.

Decision-makers can use this insight to optimize pricing, promotional strategies, and stock planning for each category.

# 📈 Case Study 3: Monthly Revenue Trend

**📌 Question:**

**Show monthly total revenue for the last 2 years.**

🧾 SQL Queries:

✅ Solution 1: Gross Revenue (Before Discounts/Promo/Returns)
```sql
select date_format(d.date,'%Y-%m') as months,sum(p.price*o.quantity) as gross_revenue
from dim_date d inner join fact_orders o 
on d.date_id = o.date_id 
inner join dim_product p on p.product_id = o.product_id
where d.date>= date_sub((select max(date) from dim_date), interval 2 year)
group by months
order by months;
```
📊 Output (Gross Revenue):
| months  | gross_revenue |
|---------|---------------|
| 2023-01 | 56110.89      |
| 2023-02 | 44360.4       |
| 2023-03 | 1465.42       |

✅ Solution 2: Net Revenue (After Discounts/Promo/Returns)
```sql
select date_format(d.date,'%Y-%m') as months, sum(o.final_price) as net_revenue
from dim_date d inner join fact_orders o 
on d.date_id = o.date_id
where d.date >= date_sub((select max(date) from dim_date), interval 2 year)
group by months
order by months;
```
📊 Output (Net Revenue):
| months  | net_revenue |
|---------|-------------|
| 2023-01 | 50316.18    |
| 2023-02 | 40129.94    |
| 2023-03 | 1290.41     |

**💡 Insight:**

Revenue shows a strong start in Jan 2023 (highest month), followed by a noticeable decline in Feb.

March 2023 revenue drops sharply to almost negligible compared to Jan & Feb → may indicate seasonality, stockout, or reduced demand.

Discounts and returns reduce overall revenue by ~10% across months.

Consistent difference between gross vs. net shows that discounts/promo campaigns are applied evenly.

**🏆 Business Value:**

Monthly trend analysis helps track seasonal demand and promotional impacts.

Sudden dips (like Mar 2023) can alert management to investigate operational or marketing issues.

Enables better forecasting and inventory planning for peak and off-peak months.

# 👥 Case Study 4: Customer Segmentation by Age Group

**📌 Question:**

**Which age group contributes the most revenue?**

🧾 SQL Queries:

✅ Solution 1: Gross Revenue (Before Discounts/Promo/Returns)
```sql
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
```
📊 Output (Gross Revenue):
| age_group | gross_revenue |
|-----------|---------------|
| 40-49     | 29765.96      |
| 30-39     | 27709.21      |
| 20-29     | 25933.22      |
| 50+       | 12542.25      |
| <20       | 5986.07       |

✅ Solution 2: Net Revenue (After Discounts/Promo/Returns)
```sql
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
```
📊 Output (Net Revenue):
| age_group | net_revenue |
|-----------|-------------|
| 40-49     | 26553       |
| 30-39     | 24999.99    |
| 20-29     | 23286.75    |
| 50+       | 11334.35    |
| <20       | 5562.44     |

**💡 Insight:**

Customers in the 40–49 age group generate the highest revenue, both gross ($29.7K) and net ($26.5K).

The 30–39 and 20–29 age groups also contribute significantly, making up the next two major segments.

Younger (<20) and older (50+) age groups contribute much less revenue, suggesting limited purchasing power or lower engagement.

Discounts and returns reduce overall revenue by roughly 10–12% across age groups.

**🏆 Business Value:**

Targeting 40–49 and 30–39 age groups with premium products and loyalty programs can maximize revenue.

20–29 age group is a strong emerging segment → effective digital marketing & student-friendly discounts may grow this base further.

Understanding age-group revenue helps with personalized marketing, product positioning, and pricing strategy.
