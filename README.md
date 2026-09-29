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

- How many new customers are acquired each month, based on their first invoice date? 
- What share of customers who first purchased in a given month placed a second order within 90 days? 
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

### 4.1. Growth & revenue

- How has monthly revenue trended over the two years, and which months show clear seasonality? 




