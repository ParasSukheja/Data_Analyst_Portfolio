-- Creating DataBase
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- 1. Dimension: Customer
CREATE TABLE dim_customer(
customer_id INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
gender VARCHAR(10),
age INT,
location VARCHAR(255),
preferred_payment VARCHAR(50)
);

-- 2. Dimension: Product
CREATE TABLE dim_product(
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
category VARCHAR(50),
brand VARCHAR(100),
color VARCHAR(20),
price DOUBLE
);

-- 3. Dimension: Payment
CREATE TABLE dim_payment(
payment_id INT PRIMARY KEY,
method VARCHAR(50)
);

-- 4. Dimension: Shipping
CREATE TABLE dim_shipping(
shipping_id INT PRIMARY KEY,
type VARCHAR(50),
cost DOUBLE
);

-- 5. Dimension: Date
CREATE TABLE dim_date(
date_id INT PRIMARY KEY,
date DATE,
day INT,
month INT,
year INT,
month_name VARCHAR(20)
);

-- 6. Fact: Orders (links to all dimensions)
CREATE TABLE fatc_orders(
order_id INT PRIMARY KEY,
customer_id INT,
product_id INT,
payment_id INT,
shipping_id INT,
date_id INT,
quantity INT,
discount_pct DECIMAL(5,2),
final_price DECIMAL(10,2),
review_rating INT,
promo_code_used BOOLEAN,
return_flag BOOLEAN,

CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
CONSTRAINT fk_payment FOREIGN KEY (payment_id) REFERENCES dim_payment(payment_id),
CONSTRAINT fk_shipping FOREIGN KEY (shipping_id) REFERENCES dim_shipping(shipping_id),
CONSTRAINT fk_date FOREIGN KEY (date_id) REFERENCES dim_date(date_id)
);


