-- Revenue per country & share of revenue among countries
-- Business question: Which countries generate the most revenue, and how concentrated is it in the UK vs. international markets?

select "Country", round(sum(revenue)::numeric, 2) as total_revenue, round((sum(revenue)/sum(sum(revenue)) over () * 100)::numeric, 1) as pct_of_total
from online_retail_sales
group by "Country"
order by total_revenue desc
limit 10;
