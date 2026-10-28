-- Olist E-commerce Analysis: 05 Flat table for Power BI
USE olist;
DROP TABLE IF EXISTS dashboard_data;

CREATE TABLE dashboard_data AS
SELECT oi.order_id,
       oi.order_item_id,
       c.customer_unique_id,
       c.customer_state,
       c.customer_city,
       DATE(o.order_purchase_timestamp) AS order_date,
       DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
       t.product_category_name_english AS category,
       oi.price,
       oi.freight_value,
       rv.review_score,
       CASE WHEN o.order_delivered_customer_date IS NULL THEN 'Unknown'
            WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'On time'
            ELSE 'Late' END AS delivery_status,
       DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
LEFT JOIN (SELECT order_id, AVG(review_score) AS review_score
           FROM reviews GROUP BY order_id) rv ON o.order_id = rv.order_id
WHERE o.order_status = 'delivered';

-- Check: revenue should be 13,221,498.11
SELECT COUNT(*), ROUND(SUM(price),2) FROM dashboard_data;
