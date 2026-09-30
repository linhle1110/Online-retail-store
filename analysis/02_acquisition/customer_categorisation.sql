-- Customer categorisation: Active, Churned
-- Business question: Which customers haven't ordered in the last 6 months, and would count as churned?

with purchase as (
  select distinct "Customer ID", "InvoiceDate"::date as purchase_date
  from online_retail_sales
  where "Customer ID" is not null
),
reference_date as (
  select max(purchase_date) as ref_date
  from purchase
),
last_order as (
  select "Customer ID", max(purchase_date) as last_order_date 
  from purchase
  group by "Customer ID"
)
select last_order."Customer ID", last_order.last_order_date, reference_date.ref_date - last_order.last_order_date as days_since_last_order, 
      case
        when reference_date.ref_date - last_order.last_order_date < 180 then 'Active'
      else 'Churned'
      end as churn_status
from last_order, reference_date;
