-- Olist E-commerce Analysis: 03 Business questions
-- Only delivered orders are used. Revenue = SUM(item price), freight excluded.
USE olist;

-- Q1. Overall KPIs
SELECT
  COUNT(DISTINCT o.order_id) AS total_orders,
  COUNT(DISTINCT c.customer_unique_id) AS unique_customers,
  ROUND(SUM(oi.price), 2) AS total_revenue,
  ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- Q2. Monthly revenue trend with growth (CTE + window function)
WITH monthly AS (
  SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
         ROUND(SUM(oi.price), 2) AS revenue
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY month
)
SELECT month, revenue,
       LAG(revenue) OVER (ORDER BY month) AS prev_month,
       ROUND((revenue - LAG(revenue) OVER (ORDER BY month))
             / LAG(revenue) OVER (ORDER BY month) * 100, 1) AS growth_pct
FROM monthly
ORDER BY month;

-- Q3. Top 10 product categories by revenue
SELECT t.product_category_name_english AS category,
       ROUND(SUM(oi.price), 2) AS revenue,
       COUNT(DISTINCT oi.order_id) AS orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_name_translation t
     ON p.product_category_name = t.product_category_name
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY t.product_category_name_english
ORDER BY revenue DESC
LIMIT 10;

-- Q4. Revenue by state
SELECT c.customer_state,
       COUNT(DISTINCT o.order_id) AS orders,
       ROUND(SUM(oi.price), 2) AS revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY revenue DESC;

-- Q5. Delivery delay vs review score
SELECT
  CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
       THEN 'On time' ELSE 'Late' END AS delivery_status,
  COUNT(*) AS orders,
  ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM orders o
JOIN reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY delivery_status;

-- Q6. Repeat purchase rate
WITH cust_orders AS (
  SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS orders
  FROM orders o
  JOIN customers c ON o.customer_id = c.customer_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id
)
SELECT COUNT(*) AS customers,
       SUM(orders > 1) AS repeat_customers,
       ROUND(SUM(orders > 1) / COUNT(*) * 100, 2) AS repeat_rate_pct
FROM cust_orders;
