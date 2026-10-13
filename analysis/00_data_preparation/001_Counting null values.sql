-- Calculate the number of missing values by subtracting the total number of populated entries in a column from the total number of rows in the table

SELECT
  COUNT(*) AS total_rows,
  COUNT(*) - COUNT("Invoice") AS null_invoice,
  COUNT(*) - COUNT("StockCode") AS null_stockcode,
  COUNT(*) - COUNT("Description") AS null_description,
  COUNT(*) - COUNT("Quantity") AS null_quantity,
  COUNT(*) - COUNT("InvoiceDate") AS null_invoicedate,
  COUNT(*) - COUNT("Price") AS null_price,
  COUNT(*) - COUNT("Customer ID") AS null_customer_id,
  COUNT(*) - COUNT("Country") AS null_country
FROM online_retail;
