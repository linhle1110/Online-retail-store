-- Cancellation rate by country and month
-- Business question: What proportion of invoices are cancellations, and does that rate vary by country or month?

#Total cancellation rate
SELECT
    COUNT(DISTINCT "Invoice") as total_invoices,
    COUNT(DISTINCT "Invoice") FILTER (WHERE "Invoice" LIKE 'C%') AS cancelled_invoices,
    ROUND(100.0 * COUNT(DISTINCT "Invoice") FILTER (WHERE "Invoice" LIKE 'C%')
          / COUNT(DISTINCT "Invoice"), 2) AS cancel_rate_pct
FROM online_retail;

#Cancellation rate by country
SELECT
    "Country",
    COUNT(DISTINCT "Invoice") as total_invoices,
    COUNT(DISTINCT "Invoice") FILTER (WHERE "Invoice" LIKE 'C%') AS cancelled_invoices,
    ROUND(100.0 * COUNT(DISTINCT "Invoice") FILTER (WHERE "Invoice" LIKE 'C%')
          / COUNT(DISTINCT "Invoice"), 2) AS cancel_rate_pct
FROM online_retail
GROUP BY "Country"
HAVING COUNT(DISTINCT "Invoice") >= 50
ORDER BY cancel_rate_pct DESC;

#Cancellation rate by month
SELECT
    DATE_TRUNC('month', "InvoiceDate")::date as month,
    COUNT(DISTINCT "Invoice") as total_invoices,
    COUNT(DISTINCT "Invoice") FILTER (WHERE "Invoice" LIKE 'C%') AS cancelled_invoices,
    ROUND(100.0 * COUNT(DISTINCT "Invoice") FILTER (WHERE "Invoice" LIKE 'C%')
          / COUNT(DISTINCT "Invoice"), 2) AS cancel_rate_pct
FROM online_retail
GROUP BY DATE_TRUNC('month', "InvoiceDate")::date
HAVING COUNT(DISTINCT "Invoice") >= 50
ORDER BY month;
