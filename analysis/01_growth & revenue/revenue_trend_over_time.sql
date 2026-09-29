-- Monthly revenue & revenue growth percentage
-- Business question: How has monthly revenue trended over the two years, and which months show clear seasonality?
with monthly as (
  select date_trunc('month', "InvoiceDate")::date as month, sum(revenue) as monthly_revenue
  from online_retail_sales
  group by date_trunc('month', "InvoiceDate")
)
select month, round(monthly_revenue::numeric, 2) as this_month_revenue, round(lag(monthly_revenue) over (order by month)::numeric, 2) as prev_month_revenue, 
  round(((monthly_revenue - lag(monthly_revenue) over (order by month))/lag(monthly_revenue) over (order by month) * 100)::numeric, 2) as percentage_change
from monthly
order by month; 
