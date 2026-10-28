-- Olist E-commerce Analysis: 02 Data cleaning
USE olist;
SET SQL_SAFE_UPDATES = 0;

-- Remove the corrupted review row (a line break in a comment shifted the columns)
DELETE FROM reviews WHERE review_creation_date NOT LIKE '20%';

-- Checks: hidden characters, duplicates, missing values
SELECT DISTINCT order_status, LENGTH(order_status) FROM orders;
SELECT LENGTH(order_estimated_delivery_date) AS len, COUNT(*) FROM orders GROUP BY len;
SELECT COUNT(*) - COUNT(DISTINCT order_id) AS dup_orders FROM orders;
SELECT COUNT(*) - COUNT(DISTINCT customer_id) AS dup_customers FROM customers;
SELECT
  SUM(order_approved_at = '') AS missing_approved,
  SUM(order_delivered_carrier_date = '') AS missing_carrier,
  SUM(order_delivered_customer_date = '') AS missing_delivered
FROM orders;

-- Empty text to NULL
UPDATE orders SET order_approved_at = NULL WHERE order_approved_at = '';
UPDATE orders SET order_delivered_carrier_date = NULL WHERE order_delivered_carrier_date = '';
UPDATE orders SET order_delivered_customer_date = NULL WHERE order_delivered_customer_date = '';

-- Text dates to DATETIME
ALTER TABLE orders
  MODIFY order_purchase_timestamp DATETIME,
  MODIFY order_approved_at DATETIME,
  MODIFY order_delivered_carrier_date DATETIME,
  MODIFY order_delivered_customer_date DATETIME,
  MODIFY order_estimated_delivery_date DATETIME;

ALTER TABLE reviews
  MODIFY review_creation_date DATETIME,
  MODIFY review_answer_timestamp DATETIME;

ALTER TABLE order_items
  MODIFY shipping_limit_date DATETIME;

-- Indexes to speed up joins
CREATE INDEX idx_orders_order ON orders(order_id);
CREATE INDEX idx_orders_cust ON orders(customer_id);
CREATE INDEX idx_cust ON customers(customer_id);
CREATE INDEX idx_items_order ON order_items(order_id);
CREATE INDEX idx_items_prod ON order_items(product_id);
CREATE INDEX idx_pay_order ON payments(order_id);
CREATE INDEX idx_rev_order ON reviews(order_id);
CREATE INDEX idx_prod ON products(product_id);
CREATE INDEX idx_trans_cat ON product_category_name_translation(product_category_name);
CREATE INDEX idx_prod_cat ON products(product_category_name);
CREATE INDEX idx_items_order_prod ON order_items(order_id, product_id);

ANALYZE TABLE orders, order_items, products, product_category_name_translation;
