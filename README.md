# Online Retail Store Project with PostgreSQL 

## 1. Introduction

This project analyses the Online Retail II UCI dataset, which includes all transactions from a UK-based online retail store from 01/12/2009 to 09/12/2011. The company's main product is giftware, and most of its customers are wholesalers. The project aims to provide meaningful insights into growth and revenue, customer acquisition and retention, customer segmentation, and business operations. The project uses SQL for data cleaning and analysis and Power BI for visualisation, transforming data into key patterns to drive business improvements.

## 2. Dataset and project overview

### 2.1. Dataset overview

The dataset captures approximately 1.07 million transactions from an online retail store, with one row per product line within an invoice. It has 8 columns, as shown in the summary table. 
[Link to dataset](https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci?resource=download)

| Column | Type | Description |
|---|---|---|
| `invoice` | Text | Six-digit invoice number. Codes starting with "C" indicate cancellations |
| `stock_code` | Text | Five-digit product code |
| `description` | Text | Product name |
| `quantity` | Integer | Units of the product in the transaction |
| `invoice_date` | Timestamp | Date and time the transaction was generated |
| `price` | Numeric | Unit price in pounds sterling (GBP) |
| `customer_id` | Text | Five-digit customer identifier |
| `country` | Text | Country where the customer resides |

### 2.2. Project overview

**Business questions**

*Growth & revenue*

- How has monthly revenue trended over the two years, and which months show clear seasonality? 
- Which countries generate the most revenue, and how concentrated is it in the UK vs. international markets? 
- Which products drive the largest share of revenue, and how much comes from just the top 20? 

*Acquisition*

- How many new customers are acquired each month, based on their first invoice date? What share of customers who first purchased in a given month placed a second order within 90 days? 
- Which customers haven't ordered in the last 6 months and would count as churned?
  
*Segmentation*
- Based on Recency, Frequency, and Monetary value, which customers are "loyal," "at-risk," or "one-time buyers"? 

*Operations*
- What proportion of invoices are cancellations, and does that rate vary by country or month? 

**SQL techniques demonstrated**

The dataset is loaded into Supabase (PostgreSQL) for analysis.
| Technique | PostgreSQL Features | Applied to |
|---|---|---|
| Data cleaning | `WHERE`, `LIKE`, `DISTINCT`, `IS NULL` | Removing duplicates, cancellations, non-product codes and invalid prices |
| Conditional logic | `CASE WHEN` | Classifying transactions (sale vs cancellation) and segmenting customers |
| Conditional aggregation | `COUNT(*) FILTER (WHERE ...)`, `SUM(...) FILTER (WHERE ...)` | Data quality checks and side-by-side metrics in one query |
| Aggregation | `GROUP BY`, `SUM`, `COUNT`, `AVG`, `HAVING` | Revenue by country, product and month; filtering groups |
| Date handling | `DATE_TRUNC`, `EXTRACT`, `INTERVAL` | Monthly trends, cohort months and recency calculations |
| Common Table Expressions | `WITH ... AS` | Breaking multi-step analyses (e.g. RFM, cohorts) into readable stages |
| Window functions: ranking | `ROW_NUMBER` | Top products per country; identifying each customer's first purchase |
| Window functions: comparison | `LAG`, `LEAD` | Month-over-month revenue growth; days between repeat purchases |
| Segmentation | `NTILE` | Scoring customers into quintiles for RFM segmentation |
| Joins | `INNER JOIN`| Combining customer summaries with cohort or segment tables |
| Subqueries | Scalar and correlated subqueries | Comparing individual values against overall averages |
| Reusable outputs | `CREATE VIEW` | Storing a cleaned base table for all downstream queries |

## 3. Data preparation 

The raw data was cleaned into a separate view, leaving the original table unchanged. All cleaning queries are in...

| Step | Issue Identified | Action Taken | 
|---|---|---|
| 1 | Missing 'customer_id' and 'description' | Kept for revenue totals; excluded from customer-level analysis |
| 2 | Duplicate rows | Created table with distinct values | 
| 3 | Cancelled invoices (prefix "C"), quantity and price < 0 |  Created view excluding these values for revenue calculation | 

Missing customer ID and product description were not deleted. They represent real sales, so removing them could understate revenue. They would be excluded where a customer identity is needed, such as RFM and customer segmentation. 

## 4. Data analysis

### 4.1. Growth & revenue: 
- How has monthly revenue trended over the two years, and which months show clear seasonality?

['analysis/01_growth_and_revenue/revenue_trend_over_time.sql'](analysis/01_growth_and_revenue/revenue_trend_over_time.sql)

Techniques: Date handling with DATE_TRUNC(), comparison window with LAG(), conditional aggregration 
  
| Month | This_month_revenue | Prev_month_revenue | Percentage_change |
|---|---|---|---|
| 2009-12-01 | 822483.95 | null | null |
| 2010-01-01 | 651155.11 | 822483.95 | -20.83 |
| 2010-02-01 | 551504.73 | 651155.11 | -15.30 |

- Which countries generate the most revenue, and how concentrated is it in the UK vs. international markets?

['analysis/01_growth_and_revenue/revenue_trend_over_time.sql'](analysis/01_growth_and_revenue/revenue_trend_over_time.sql)

Techniques: Conditional aggregation

| Country        | total_revenue | pct_of_total |
| -------------- | ------------- | ------------ |
| United Kingdom | 17410196.12   | 85.0         |
| EIRE           | 658767.31     | 3.2          |
| Netherlands    | 554038.09     | 2.7          |

- Which products drive the largest share of revenue, and how much comes from just the top 20? 

['analysis/01_growth_and_revenue/top_ranking_products.sql'](analysis/01_growth_and_revenue/top_ranking_products.sql)

Techniques: Ranking windows with rank() over, conditional aggregration

| revenue_rank | StockCode | Description                         | total_revenue | pct_of_total_revenue |
| ------------ | --------- | ----------------------------------- | ------------- | -------------------- |
| 1            | M         | Manual                              | 339226.24     | 1.7                  |
| 2            | 22423     | REGENCY CAKESTAND 3 TIER            | 330590.32     | 1.6                  |
| 3            | DOT       | DOTCOM POSTAGE                      | 309854.11     | 1.5                  |

### 4.2. Acquisition:

- How many new customers are acquired each month, based on their first invoice date? What share of customers who first purchased in a given month placed a second order within 90 days? 

Techniques: Subqueries, ranking windows with rank() over, date handling with DATE_TRUNC(), conditional aggregation

| month      | new_customers | next_purchase_within_90_days | pct_reordered_within_90 |
| ---------- | ------------- | ---------------------------- | ----------------------- |
| 2009-12-01 | 955           | 570                          | 59.00                   |
| 2010-01-01 | 383           | 196                          | 51.00                   |
| 2010-02-01 | 374           | 181                          | 48.00                   |

- Which customers haven't ordered in the last 6 months and would count as churned?

Techniques: Conditional logic, subqueries, conditional aggregation 

| Customer ID | last_order_date | days_since_last_order | churn_status |
| ----------- | --------------- | --------------------- | ------------ |
| 14920.0     | 2011-05-11      | 212                   | Churned      |
| 13192.0     | 2011-09-05      | 95                    | Active       |
| 16165.0     | 2010-07-22      | 505                   | Churned      |

### 4.3. Segmentation 

- Based on Recency, Frequency, and Monetary value, which customers are "loyal," "at-risk," or "one-time buyers"? 

Techniques: CTEs, window functions (NTILE) and rule-based classification

| Customer ID | recency | frequency | monetary | r_score | f_score | m_score | segment        |
| ----------- | ------- | --------- | -------- | ------- | ------- | ------- | -------------- |
| 17592.0     | 739     | 1         | 148.30   | 1       | 1       | 1       | one time buyer |
| 13526.0     | 739     | 2         | 1182.00  | 1       | 3       | 3       | at risk        |
| 17056.0     | 739     | 1         | 128.60   | 1       | 1       | 1       | one time buyer |

### 4.4. Operations

- What proportion of invoices are cancellations, and does that rate vary by country or month?

Techniques: Conditional aggregation, date handling with DATE_TRUNC(), 

| total_invoices | cancelled_invoices | cancel_rate_pct |
| -------------- | ------------------ | --------------- |
| 53628          | 8292               | 15.46           |

| Country         | total_invoices | cancelled_invoices | cancel_rate_pct |
| --------------- | -------------- | ------------------ | --------------- |
| Japan           | 56             | 23                 | 41.07           |
| Channel Islands | 79             | 24                 | 30.38           |
| Italy           | 92             | 27                 | 29.35           |

| month      | total_invoices | cancelled_invoices | cancel_rate_pct |
| ---------- | -------------- | ------------------ | --------------- |
| 2009-12-01 | 2330           | 401                | 17.21           |
| 2010-01-01 | 1633           | 300                | 18.37           |
| 2010-02-01 | 1969           | 240                | 12.19           |
