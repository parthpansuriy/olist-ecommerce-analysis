-- Olist E-commerce Analysis: 04 RFM customer segmentation
USE olist;

-- 4.1 One row per customer
DROP TABLE IF EXISTS rfm_base;
CREATE TABLE rfm_base AS
SELECT c.customer_unique_id,
       MAX(o.order_purchase_timestamp) AS last_purchase,
       COUNT(DISTINCT o.order_id) AS frequency,
       ROUND(SUM(oi.price), 2) AS monetary
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id;

-- 4.2 Score and segment (R and M use NTILE(5); F uses fixed rules because most customers bought once)
DROP TABLE IF EXISTS rfm_segments;
CREATE TABLE rfm_segments AS
WITH scored AS (
  SELECT customer_unique_id, frequency, monetary,
         DATEDIFF((SELECT MAX(order_purchase_timestamp) FROM orders), last_purchase) AS recency_days,
         NTILE(5) OVER (ORDER BY last_purchase ASC) AS r_score,
         CASE WHEN frequency = 1 THEN 1
              WHEN frequency = 2 THEN 3
              ELSE 5 END AS f_score,
         NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
  FROM rfm_base
)
SELECT *,
  CASE
    WHEN r_score >= 4 AND m_score >= 4 THEN 'Champions'
    WHEN r_score <= 2 AND m_score >= 4 THEN 'At Risk - High Value'
    WHEN r_score >= 4 AND m_score < 4  THEN 'Recent Customers'
    WHEN r_score <= 2 AND m_score <= 2 THEN 'Lost - Low Value'
    ELSE 'Regular'
  END AS segment
FROM scored;

-- 4.3 Segment summary
SELECT segment,
       COUNT(*) AS customers,
       ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 1) AS pct_customers,
       ROUND(SUM(monetary), 2) AS revenue,
       ROUND(SUM(monetary) * 100 / SUM(SUM(monetary)) OVER (), 1) AS pct_revenue,
       ROUND(AVG(monetary), 2) AS avg_spend
FROM rfm_segments
GROUP BY segment
ORDER BY revenue DESC;
