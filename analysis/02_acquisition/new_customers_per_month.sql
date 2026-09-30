-- New customer per month
-- Business question: How many new customers are acquired each month, based on their first invoice date? 

with first_purchase as (
  select distinct "Customer ID", "InvoiceDate"::date as purchase_date
  from online_retail_sales
),
rank_order as (
  select "Customer ID", purchase_date, row_number() over (partition by "Customer ID" order by purchase_date) as purchase_order, lead(purchase_date) over (partition by "Customer ID" order by purchase_date) as next_purchase
  from first_purchase
)
select date_trunc('month', purchase_date)::date as month, count(*) as new_customers, count(*) filter (where next_purchase is not null and next_purchase - purchase_date <= 90) as next_purchase_within_90_days, round(100 * count(*) filter (where next_purchase is not null and next_purchase - purchase_date <= 90)/count(*), 2) as pct_reordered_within_90
from rank_order
where purchase_order = 1
group by date_trunc('month', purchase_date)
order by date_trunc('month', purchase_date);
