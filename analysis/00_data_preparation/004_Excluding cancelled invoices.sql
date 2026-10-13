-- Create view excluding cancelled invoices (prefix "C"), and invoices with quantity and price < 0 for revenue calculation

create view online_retail_sales as
select "Invoice", "StockCode", "Description", "Quantity", "InvoiceDate", "Price", "Customer ID", "Country", "Quantity"*"Price" as Revenue 
from online_retail_clean
WHERE "Invoice" NOT LIKE 'C%'
AND "Quantity" > 0
AND "Price" > 0;
