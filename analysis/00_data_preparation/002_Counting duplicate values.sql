-- Counting duplicate values 

select "Invoice", "StockCode", "Description", "Quantity", "InvoiceDate", "Price", "Customer ID", "Country", COUNT(*) AS Duplicates
from online_retail
group by "Invoice", "StockCode", "Description", "Quantity", "InvoiceDate", "Price", "Customer ID", "Country"
having count(*) > 1; 
