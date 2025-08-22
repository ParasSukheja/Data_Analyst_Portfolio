# 🛒 Case Study 1: Top Selling Products

### 📌 Question:

**What are the top 10 best-selling products by quantity?**

#### 🧾 SQL Query:
```sql
select p.product_name,sum(o.quantity) as total_sold
from dim_product p inner join fact_orders o
on p.product_id = o.product_id 
group by p.product_name
order by total_sold DESC
limit 10;
```
**📊 Output:**
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

### 📌 Question:

**Which product categories generate the most revenue? Rank them.**

#### 🧾 SQL Queries:

**✅ Solution 1: Gross Revenue (Before Discounts/Promo/Returns)**
```sql
select p.category, sum(p.price*o.quantity) as gross_revenue 
from dim_product p inner join fact_orders o 
on p.product_id = o.product_id
group by p.category 
order by gross_revenue DESC;
```
**📊 Output (Gross Revenue):**
| category    | gross_revenue |
|-------------|---------------|
| Home        | 37229.16      |
| Electronics | 27289.98      |
| Clothing    | 20445.82      |
| Accessories | 16971.75      |

**✅ Solution 2: Net Revenue (After Discounts/Promo/Returns)**
```sql
select p.category,sum(o.final_price) as net_revenue
from dim_product p inner join fact_orders o
on p.product_id = o.product_id
group by p.category
order by net_revenue DESC;
```
**📊 Output (Net Revenue):**
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

### 📌 Question:

**Show monthly total revenue for the last 2 years.**

#### 🧾 SQL Queries:

**✅ Solution 1: Gross Revenue (Before Discounts/Promo/Returns)**
```sql
select date_format(d.date,'%Y-%m') as months,sum(p.price*o.quantity) as gross_revenue
from dim_date d inner join fact_orders o 
on d.date_id = o.date_id 
inner join dim_product p on p.product_id = o.product_id
where d.date>= date_sub((select max(date) from dim_date), interval 2 year)
group by months
order by months;
```
**📊 Output (Gross Revenue):**
| months  | gross_revenue |
|---------|---------------|
| 2023-01 | 56110.89      |
| 2023-02 | 44360.4       |
| 2023-03 | 1465.42       |

**✅ Solution 2: Net Revenue (After Discounts/Promo/Returns)**
```sql
select date_format(d.date,'%Y-%m') as months, sum(o.final_price) as net_revenue
from dim_date d inner join fact_orders o 
on d.date_id = o.date_id
where d.date >= date_sub((select max(date) from dim_date), interval 2 year)
group by months
order by months;
```
**📊 Output (Net Revenue):**
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

### 📌 Question:

**Which age group contributes the most revenue?**

#### 🧾 SQL Queries:

**✅ Solution 1: Gross Revenue (Before Discounts/Promo/Returns)**
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
**📊 Output (Gross Revenue):**
| age_group | gross_revenue |
|-----------|---------------|
| 40-49     | 29765.96      |
| 30-39     | 27709.21      |
| 20-29     | 25933.22      |
| 50+       | 12542.25      |
| <20       | 5986.07       |

**✅ Solution 2: Net Revenue (After Discounts/Promo/Returns)**
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
**📊 Output (Net Revenue):**
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

# 💸 Case Study 5: Impact of Discounts

### 📌 Question:

**Compare average revenue per order with and without discounts.**

#### 🧾 SQL Queries:

**✅ Solution 1: Gross Revenue per Order (Before Discounts/Promo/Returns)**
```sql
select round(avg(order_gross_revenue),2) as avg_gross_revenue_per_order from
(select o.order_id,sum(p.price*o.quantity) as order_gross_revenue 
from dim_product p inner join fact_orders o
on p.product_id = o.product_id
group by o.order_id) as der_tab;
```
**📊 Output (Gross Revenue):**
| avg_gross_revenue_per_order |
|-----------------------------|
| 407.75                      |

**✅ Solution 2: Net Revenue per Order (After Discounts/Promo/Returns)**
```sql
select round(avg(order_net_revenue),2) as avg_net_revenue_per_order from
(select order_id,sum(final_price) as order_net_revenue
from  fact_orders
group by order_id) as der_tab;
```
**📊 Output (Net Revenue):**
| avg_net_revenue_per_order |
|---------------------------|
| 366.95                    |

**💡 Insight:**

The average gross revenue per order is ₹407.75.

After accounting for discounts, promo codes, and returns, the average net revenue per order drops to ₹366.95.

This indicates that discounts reduce average order value by ~10%.

**🏆 Business Value:**

While discounts drive customer acquisition and sales volume, they also shrink per-order profitability.

Businesses should monitor discount strategies carefully to balance growth vs. profit margin.

A possible strategy: use discounts for low-performing products or festive campaigns rather than across all categories.

# 💳 Case Study 6: Payment Method Preference

### 📌 Question:

**What are the most popular payment methods among customers?**

#### 🧾 SQL Query:
```sql
select p.method, count(o.order_id) as total_order 
from dim_payment p inner join fact_orders o
on p.payment_id = o.payment_id
group by method
order by total_order DESC
limit 1;
```
**📊 Output:**
| method           | total_order |
|------------------|-------------|
| Cash on Delivery | 99          |

**💡 Insight:**

Cash on Delivery (COD) is the most preferred payment method among customers, with 99 orders.

This indicates that many customers still trust physical payment at delivery over online methods.

**🏆 Business Value:**

Reliance on COD may highlight trust concerns with digital payments, especially for new customers.

COD transactions can increase operational risk (returns, refusals, handling costs).

To improve profitability, businesses should encourage digital payments by:

Offering exclusive discounts or rewards for prepaid orders.

Providing secure and seamless payment gateways.

Building trust with refund policies for online payments.

# 🚚 Case Study 7: Shipping Type Impact

### 📌 Question:

**Do customers who choose Express shipping spend more than Standard shipping customers?**

#### 🧾 SQL Queries:

**🧾 Solution 1: Average Gross Revenue per Order (Before Discounts/Returns)**
```sql
select shipping_id,type, round(avg(order_total),2) as avg_gross_revenue_per_order from
(select o.order_id, s.shipping_id,s.type ,sum(p.price*o.quantity) as order_total
from dim_product p inner join fact_orders o 
on p.product_id = o.product_id 
inner join dim_shipping s on s.shipping_id = o.shipping_id
group by o.order_id,s.shipping_id,s.type
) as der_tab
group by shipping_id , type
order by avg_gross_revenue_per_order DESC;
```
**📊 Output:**
| shipping_id | type     | avg_gross_revenue_per_order |
|-------------|----------|-----------------------------|
| 1           | Standard | 443.31                      |
| 2           | Express  | 393.84                      |
| 3           | Same-Day | 385.56                      |

**🧾 Solution 2: Average Net Revenue per Order (After Discounts/Returns)**
```sql
select shipping_id, type, round(avg(order_total),2) as avg_net_revenue_per_order from
(select o.order_id, s.shipping_id, s.type, sum(o.final_price) as order_total
from dim_shipping s inner join fact_orders o 
on s.shipping_id = o.shipping_id
group by o.order_id,s.shipping_id,s.type
) as der_table
group by shipping_id, type
order by avg_net_revenue_per_order DESC;
```
**📊 Output:**
| shipping_id | type     | avg_net_revenue_per_order |
|-------------|----------|---------------------------|
| 1           | Standard | 403.05                    |
| 3           | Same-Day | 349.03                    |
| 2           | Express  | 348.33                    |

**💡 Insights**

**From Gross Revenue (Before Discounts/Returns):**

Standard shipping leads with the highest order value ($443.31/order).

Express ($393.84) and Same-Day ($385.56) are lower, showing that urgent shipping is used more for smaller transactions.

**From Net Revenue (After Discounts/Returns):**

The trend remains the same: Standard customers still spend the most ($403.05/order).

Express drops further ($348.33/order), becoming the lowest among all shipping types.

Discounts, promo codes, and returns reduce revenue more significantly for Express orders compared to Standard.

**🏆 Business Value**

**From Gross Revenue:**

Customers choosing Standard shipping likely place larger, planned purchases, driving higher revenue before discounts.

Express & Same-Day customers appear to be more impulsive/urgent buyers, but with smaller cart sizes.

**From Net Revenue:**

After considering discounts and returns, the gap widens — Express and Same-Day are impacted more heavily, which suggests these customers are more price-sensitive (use more discounts) or more prone to returns.

Standard shipping customers not only spend more but also provide more stable and reliable revenue post-discounts.

# 🧑‍🤝‍🧑 Case Study 8: Customer Loyalty

### 📌 Question:

**Who are the top 5 customers with the highest number of orders?**

#### 🧾 SQL Queries:
```sql
select customer_id,count(order_id) as total_orders
from fact_orders
group by customer_id
order by total_orders DESC
limit 5;
```
**📊 Output:**
| customer_id | total_orders |
|-------------|--------------|
| 10          | 12           |
| 41          | 11           |
| 48          | 10           |
| 42          | 10           |
| 34          | 9            |

**💡 Insights**

Customer 10 is the most loyal with 12 orders, followed closely by Customer 41 (11 orders).

The top 5 customers placed between 9–12 orders each, showing consistent repeat purchase behavior.

These customers are likely brand-loyal advocates who prefer this e-commerce store over competitors.

**🏆 Business Value**

Retention & Rewards

High-frequency buyers are ideal for loyalty programs (exclusive offers, free shipping, early product launches).

Personalized rewards can keep them engaged and increase repeat orders.

Customer Lifetime Value (CLV)

These customers have higher CLV than average buyers.

Retaining them is more cost-effective than acquiring new customers.

Referral Potential

Loyal customers can act as brand advocates.

Offering referral bonuses could turn them into drivers of new customer acquisition.

# 📦 Case Study 9: Product Return Analysis

### 📌 Question:

**What percentage of orders are returned, and which product category has the highest return rate?**

#### 🧾 SQL Queries:

**Step 1: Overall Percentage of Orders Returned**
```sql
select round(100.0*sum(case when return_flag = 1 then 1 else 0 end) / count(*),2) 
as return_percentage
from fact_orders;
```
**📊 Output:**
| return_percentage |
|-------------------|
| 54.4              |

**Step 2: Category with Highest Return Rate**
```sql
select p.category, round(100.0*sum(case when o.return_flag = 1 then 1 else 0 end) / count(*),2)
as return_percentage
from fact_orders o inner join dim_product p
on o.product_id = p.product_id
group by  p.category
order by return_percentage DESC;
```
**📊 Output:**
| category    | return_percentage |
|-------------|-------------------|
| Clothing    | 64.91             |
| Accessories | 58.73             |
| Electronics | 53.97             |
| Home        | 41.79             |

**💡 Insights**

Over half (54.4%) of all orders are returned, indicating a major operational challenge.

Clothing (64.91%) has the highest return rate, which is common in e-commerce due to size, fit, or style mismatches.

Accessories (58.73%) and Electronics (53.97%) also show high returns, suggesting possible quality issues, mismatched expectations, or product descriptions not aligning with reality.

Home products (41.79%) have the lowest return rate, likely because these items are easier to match expectations.

**🏆 Business Value**

Operational Efficiency

High return rates increase logistics costs, inventory handling, and customer service workload.

Addressing return issues can save millions in supply chain costs.

Product Improvements

Clothing returns highlight the need for better size guides, AR try-ons, or customer reviews visibility.

Electronics returns suggest the need for clearer specifications, product demos, or better quality checks.

Customer Experience & Trust

High returns damage customer trust and reduce repeat purchases.

Improving product descriptions and quality can lead to higher customer satisfaction.

Profitability

Reducing returns by even 5–10% could significantly improve net revenue and operational margins.

# 🎯 Case Study 10: Promotion Effectiveness

### 📌 Question:

**Compare the average revenue per order where a promo code was used vs. not used.**

#### 🧾 SQL Queries:

**Step 1: Promotion Effectiveness (Gross Revenue)**
```sql
select promo_code_used, round(avg(order_gross_revenue),2) as avg_gross_revenue_per_order from
(select o.order_id,o.promo_code_used,sum(p.price*o.quantity) as order_gross_revenue
from fact_orders o inner join dim_product p
on o.product_id = p.product_id
group by o.order_id, o.promo_code_used) as der_tab
group by promo_code_used;
```
**📊 Output:**
| promo_code_used | avg_gross_revenue_per_order |
|-----------------|-----------------------------|
| 0               | 416.11                      |
| 1               | 399.11                      |

**Step 2: Promotion Effectiveness (Net Revenue)**
```sql
select promo_code_used, round(avg(order_net_revenue),2) as avg_net_revenue_per_order from
(select order_id,promo_code_used,sum(final_price) as order_net_revenue
from fact_orders
group by order_id, promo_code_used) as der_tab
group by promo_code_used;
```
**📊 Output:**
| promo_code_used | avg_net_revenue_per_order |
|-----------------|---------------------------|
| 1               | 360.05                    |
| 0               | 373.63                    |

**💡 Insights**

**Gross Revenue Perspective:**

Orders without promo codes generate slightly higher gross revenue (416.11) compared to orders with promo codes (399.11).

This suggests promo usage does not significantly increase cart size.

**Net Revenue Perspective (after discounts):**

Orders with promo codes generate lower net revenue (360.05) than orders without promo codes (373.63).

This means discounts are reducing profitability per order without driving a substantial increase in order value.

Customers may be using promos without necessarily buying more items, so the intended uplift in order size or frequency might not be achieved.

**🏆 Business Value**

Promo Strategy Optimization

Current promos are not increasing average order revenue, indicating a need to redesign promotions.

Instead of blanket discounts, consider targeted promos (e.g., category-specific, minimum spend thresholds).

Profitability Protection

Since net revenue per promo order is lower, frequent promo usage may erode profit margins.

Company should set a limit on promo usage or tie promos to loyalty/repeat purchases.

Customer Behavior Insight

Promos are likely attracting deal-seekers rather than encouraging larger baskets or upsells.

Better promo design can convert promos into growth drivers instead of margin killers.
