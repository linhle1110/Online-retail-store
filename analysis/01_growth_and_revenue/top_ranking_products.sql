-- Top-ranking products
-- Business question: Which products drive the largest share of revenue

select rank() over (order by sum(revenue) desc) as revenue_rank, "StockCode", "Description", round(sum(revenue)::numeric, 2) as total_revenue, round((sum(revenue)/sum(sum(revenue)) over () * 100)::numeric, 1) as pct_of_total_revenue
from online_retail_sales
group by "StockCode", "Description";
