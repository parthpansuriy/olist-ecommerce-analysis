# Olist E-commerce Sales & Customer Analysis

**Tools:** MySQL, Power BI, DAX

## Business question
How is the business performing, what hurts customer satisfaction, and which customers should the company focus on?

## Dataset
Olist Brazilian E-commerce (Kaggle): 8 related tables (orders, customers, order items, payments, reviews, products, sellers, category translation). The geolocation table was not used.

## Approach
1. **Setup:** created the database and loaded the CSV files into MySQL.
2. **Cleaning:** removed 1 corrupted review row (caused by line breaks in comments), converted text dates to DATETIME, set empty values to NULL, and added indexes to speed up joins.
3. **Analysis:** used joins, CTEs and window functions to answer business questions on revenue, categories, states, delivery performance and repeat purchases.
4. **Segmentation:** scored 93,358 customers with RFM analysis.
5. **Dashboard:** built a flat analytics table in SQL and a 2-page Power BI dashboard with DAX measures, KPI cards and slicers.

**Metric definition:** only delivered orders are used. Revenue = sum of item price (excludes freight).

## Key findings
- **96,478** delivered orders, **93,358** unique customers, **13.22M** revenue, average order value **137.04**.
- Late deliveries score **2.57** on average vs **4.29** for on-time orders (7,700 late orders).
- Only **3.0%** of customers (2,801) bought more than once.
- RFM segments:

| Segment | Customers | % Customers | % Revenue | Avg spend |
|---|---|---|---|---|
| Champions | 15,441 | 16.5% | 31.6% | 270.50 |
| At Risk - High Value | 14,530 | 15.6% | 30.6% | 278.48 |
| Regular | 26,107 | 28.0% | 23.9% | 121.11 |
| Recent Customers | 21,901 | 23.5% | 9.2% | 55.69 |
| Lost - Low Value | 15,379 | 16.5% | 4.7% | 40.11 |

Champions and At Risk - High Value together are about 32% of customers but bring about 62% of revenue.

## Recommendations
1. Improve delivery estimates and logistics, since late orders are where ratings drop.
2. Offer a discount after the first delivery to lift the 3% repeat rate.
3. Run win-back offers for the 14,530 At Risk - High Value customers.
4. Reward Champions; avoid spending marketing budget on Lost - Low Value customers.

## Dashboard
![Sales Overview](dashboard_page1.png)
![Delivery and Customer Insights](dashboard_page2.png)

## Files
- `sql/`: setup, cleaning, analysis, RFM and dashboard table queries
- `olist_dashboard.pbix`: Power BI dashboard
- Screenshots of both dashboard pages
