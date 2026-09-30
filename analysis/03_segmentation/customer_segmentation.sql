-- Categorize customers into "loyal," "at-risk," or "one-time buyers"
-- Business question: Based on Recency, Frequency, and Monetary value, which customers are "loyal," "at-risk," or "one-time buyers"?

with ref as (
  select max("InvoiceDate")::date + 1 as ref_date
  from online_retail_sales
),
rfm as (
  select "Customer ID", (select ref_date from ref) - max("InvoiceDate")::date as recency, count(distinct "InvoiceDate") as frequency, round(sum("Price"*"Quantity")::numeric, 2) as monetary
  from online_retail_sales
  where "Customer ID" is not null
  group by "Customer ID"
),
rfm_scores as (
  select *, ntile(5) over (order by recency desc) as r_score, ntile(5) over (order by frequency) as f_score, ntile(5) over (order by monetary) as m_score
  from rfm
)
select "Customer ID", recency, frequency, monetary, r_score, f_score, m_score,
      case
        when frequency = 1 then 'one time buyer'
        when r_score >=4 AND f_score >=4 then 'loyal'
        when r_score <=2 and f_score >=3 then 'at risk'
      end as segment
from rfm_scores
limit 5;
