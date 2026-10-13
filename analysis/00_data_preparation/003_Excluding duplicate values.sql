-- Create new table excluding duplicate values

create table online_retail_clean as select distinct * from online_retail;
