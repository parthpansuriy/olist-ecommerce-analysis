-- Olist E-commerce Analysis: 01 Setup
-- Creates the database and tables, then loads the CSV files.
-- Change the folder path in each LOAD DATA line to where your CSV files are.

SET GLOBAL local_infile = 1;

DROP DATABASE IF EXISTS olist;
CREATE DATABASE olist;
USE olist;

CREATE TABLE customers (
  customer_id VARCHAR(50),
  customer_unique_id VARCHAR(50),
  customer_zip_code_prefix VARCHAR(10),
  customer_city VARCHAR(100),
  customer_state VARCHAR(5)
);

CREATE TABLE orders (
  order_id VARCHAR(50),
  customer_id VARCHAR(50),
  order_status VARCHAR(20),
  order_purchase_timestamp VARCHAR(30),
  order_approved_at VARCHAR(30),
  order_delivered_carrier_date VARCHAR(30),
  order_delivered_customer_date VARCHAR(30),
  order_estimated_delivery_date VARCHAR(30)
);

CREATE TABLE order_items (
  order_id VARCHAR(50),
  order_item_id INT,
  product_id VARCHAR(50),
  seller_id VARCHAR(50),
  shipping_limit_date VARCHAR(30),
  price DECIMAL(10,2),
  freight_value DECIMAL(10,2)
);

CREATE TABLE payments (
  order_id VARCHAR(50),
  payment_sequential INT,
  payment_type VARCHAR(30),
  payment_installments INT,
  payment_value DECIMAL(10,2)
);

CREATE TABLE reviews (
  review_id VARCHAR(50),
  order_id VARCHAR(50),
  review_score INT,
  review_comment_title VARCHAR(255),
  review_comment_message TEXT,
  review_creation_date VARCHAR(30),
  review_answer_timestamp VARCHAR(30)
);

CREATE TABLE products (
  product_id VARCHAR(50),
  product_category_name VARCHAR(100),
  product_name_lenght INT,
  product_description_lenght INT,
  product_photos_qty INT,
  product_weight_g INT,
  product_length_cm INT,
  product_height_cm INT,
  product_width_cm INT
);

CREATE TABLE sellers (
  seller_id VARCHAR(50),
  seller_zip_code_prefix VARCHAR(10),
  seller_city VARCHAR(100),
  seller_state VARCHAR(5)
);

CREATE TABLE product_category_name_translation (
  product_category_name VARCHAR(100),
  product_category_name_english VARCHAR(100)
);

LOAD DATA LOCAL INFILE 'C:/Users/DC/Downloads/archive (9)/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/DC/Downloads/archive (9)/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/DC/Downloads/archive (9)/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/DC/Downloads/archive (9)/olist_order_payments_dataset.csv'
INTO TABLE payments
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/DC/Downloads/archive (9)/olist_order_reviews_dataset.csv'
INTO TABLE reviews
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/DC/Downloads/archive (9)/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/DC/Downloads/archive (9)/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- Products has empty numeric cells, so they are converted to NULL
LOAD DATA LOCAL INFILE 'C:/Users/DC/Downloads/archive (9)/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS
(product_id, @cat, @nl, @dl, @pq, @w, @l, @h, @wd)
SET product_category_name = NULLIF(@cat,''),
    product_name_lenght = NULLIF(@nl,''),
    product_description_lenght = NULLIF(@dl,''),
    product_photos_qty = NULLIF(@pq,''),
    product_weight_g = NULLIF(@w,''),
    product_length_cm = NULLIF(@l,''),
    product_height_cm = NULLIF(@h,''),
    product_width_cm = NULLIF(@wd,'');

-- Verify row counts
SELECT 'customers' AS tbl, COUNT(*) AS total FROM customers
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'payments', COUNT(*) FROM payments
UNION ALL SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'translation', COUNT(*) FROM product_category_name_translation;
