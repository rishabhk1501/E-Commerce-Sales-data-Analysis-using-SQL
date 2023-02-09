/* Create The Table */
CREATE TABLE IF NOT EXISTS store (
Row_ID SERIAL,
Order_ID CHAR(25),
Order_Date DATE,
Ship_Date DATE,
Ship_Mode VARCHAR(50),
Customer_ID CHAR(25),
Customer_Name VARCHAR(75),
Segment VARCHAR(25),
Country VARCHAR(50),
City VARCHAR(50),
States VARCHAR(50),
Postal_Code INT,
Region VARCHAR(12),
Product_ID VARCHAR(75),
Category VARCHAR(25),
Sub_Category VARCHAR(25),
Product_Name VARCHAR(255),
Sales FLOAT,
Quantity INT,
Discount FLOAT,
Profit FLOAT,
Discount_amount FLOAT,
Years INT,
Customer_Duration VARCHAR(50),
Returned_Items VARCHAR(50),
Return_Reason VARCHAR(255)
) 

/* checking the raw Table */
SELECT * FROM store

/* Importing csv file */
/* First dataset look */
SELECT * FROM store

/*Database Size/Table size
pg_database_size/pg_relation_size
returns size in bytes, for MB, KB, 
GB etc we use pg_size_pretty function*/

SELECT pg_size_pretty(pg_database_size('Project'))
SELECT pg_size_pretty(pg_relation_size('store'))

-- DATASET  INFORMATION
-- Customer_Name   : Customer's Name
-- Customer_Id  : Unique Id of Customers
-- Segment : Product Segment
-- Country : United States
-- City : City of the product ordered
-- State : State of product ordered
-- Product_Id : Unique Product ID
-- Category : Product category
-- Sub_Category : Product sub category
-- Product_Name : Name of the product
-- Sales : Sales contribution of the order
-- Quantity : Quantity Ordered
-- Discount : % discount given
-- Profit : Profit for the order
-- Discount_Amount : discount  amount of the product 
-- Customer Duration : New or Old Customer
-- Returned_Item :  whether item returned or not
-- Returned_Reason : Reason for returning the item

/* row count of data */
SELECT COUNT(*) AS ROW_COUNT
FROM STORE

/* column count of data */
SELECT COUNT(*) AS COLUMN_COUNT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'store';

/* Check Dataset Information */
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'store'

/*  get column names of store data */
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'store'

/* get column names with data type of store data */
SELECT COLUMN_NAME, data_type
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'store'

/* checking null values of store data */
SELECT 
    *
FROM
    STORE
WHERE
    (SELECT 
            COLUMN_NAME
        FROM
            INFORMATION_SCHEMA.COLUMNS
        WHERE
            TABLE_NAME = 'store') = NULL
			
/* No Missing Values Found */

/* Dropping Unnecessary column like Row_ID */

ALTER TABLE STORE
DROP COLUMN ROW_ID

SELECT *
FROM STORE
LIMIT 10

/* PRODUCT LEVEL ANALYSIS*/
/* What are the unique product categories? */

SELECT DISTINCT CATEGORY
FROM STORE

/* What is the number of products in each category? */
SELECT CATEGORY,
	COUNT(*)
FROM STORE
GROUP BY CATEGORY
ORDER BY COUNT(*) DESC

/* Find the number of Subcategories products that are divided. */
SELECT COUNT(DISTINCT SUB_CATEGORY) AS NO_OF_SUB_CATEGORY
FROM STORE

/* Find the number of products in each sub-category. */
SELECT SUB_CATEGORY,
	COUNT(*)
FROM STORE
GROUP BY SUB_CATEGORY
ORDER BY COUNT(*) DESC

/* Find the number of unique product names. */
SELECT COUNT(DISTINCT PRODUCT_NAME) AS NO_OF_DIFF_PRODUCT
FROM STORE

/* Which are the Top 10 Products that are ordered frequently? */
SELECT PRODUCT_NAME,
	COUNT(*)
FROM STORE
GROUP BY PRODUCT_NAME
ORDER BY COUNT(*) DESC
LIMIT 10

/* Calculate the cost for each Order_ID with respective Product Name. */

SELECT ORDER_ID,
	PRODUCT_NAME,
	ROUND(CAST(SALES - PROFIT AS NUMERIC),
		2) AS COST
FROM STORE

/* Calculate % profit for each Order_ID with respective Product Name. */
SELECT ORDER_ID,
	PRODUCT_NAME,
	ROUND(CAST(((PROFIT) / (SALES - PROFIT))*100 AS numeric),
		2) AS PROFIT_PERC
FROM STORE

/* Calculate the overall percentage profit of the store. */

SELECT ROUND(CAST((SUM(PROFIT)) / (SUM(SALES) - SUM(PROFIT)) * 100 AS numeric), 2) AS TOTAL_PROFIT_PERC
FROM STORE

/* Where can we trim some loses? 
   In Which products?
   We can do this by calculating the average sales and profits, and comparing the values to that average.
   If the sales or profits are below average, then they are not best sellers and 
   can be analyzed deeper to see if its worth selling thema anymore. */

SELECT round(cast(AVG(sales) as numeric),2) AS avg_sales
FROM store;
-- the average sales on any given product is 229.8, so approx. 230.

SELECT round(cast(AVG(Profit)as numeric),2) AS avg_profit
FROM store;
-- the average profit on any given product is 28.6, or approx 29.


-- Average sales per sub-cat
SELECT round(cast(AVG(sales) as numeric),2) AS avg_sales, Sub_Category
FROM store
GROUP BY Sub_Category
ORDER BY avg_sales asc
limit 9;
--The sales of these Sub_category products are below the average sales.

-- Average profit per sub-cat
SELECT round(cast(AVG(Profit)as numeric),2) AS avg_prof,Sub_Category
FROM store
GROUP BY Sub_Category
ORDER BY avg_prof asc
limit 11;
--The profit of these Sub_category products are below the average profit.

/* CUSTOMER LEVEL ANALYSIS*/
select count(distinct (Customer_id)) as no_of_unique_custd_ID
from store

/* Calculate Total Frequency of each order id by each customer Name in descending order. */
select order_id, customer_name, count(Order_Id) as total_order_id
from store
group by order_id,customer_name
order by total_order_id desc

/* Calculate  cost of each customer name. */
select order_id, customer_id, customer_Name, City, Quantity,sales,(sales-profit) as costs,profit
from store
group by Customer_Name,order_id,customer_id,City,Quantity,Costs,sales,profit;

/* Calculate  cost of each customer name. */
select order_id, customer_id, customer_Name, City, Quantity,sales,(sales-profit) as costs,profit
from store
group by Customer_Name,order_id,customer_id,City,Quantity,Costs,sales,profit;

/* Find Top 10 customers who order frequently. */
SELECT Customer_Name, count(*) as no_of_order
FROM store
GROUP BY Customer_Name
order by  count(*) desc
limit 10

/* Find Top 20 Customers who benefitted the store.*/
SELECT Customer_Name, Profit, City, States
FROM store
GROUP BY Customer_Name,Profit,City,States
order by  Profit desc
limit 20

--Which state(s) is the superstore most succesful in? Least?
--Top 10 results:
SELECT round(cast(SUM(sales) as numeric),2) AS state_sales, States
FROM Store
GROUP BY States
ORDER BY state_sales DESC
OFFSET 1 ROWS FETCH NEXT 10 ROWS ONLY;

/* ORDER LEVEL ANALYSIS */
/* number of unique orders */
select count(distinct (Order_ID)) as no_of_unique_orders
from store

/* Find Sum Total Sales of Superstore. */
select round(cast(SUM(sales) as numeric),2) as Total_Sales
from store

/* Calculate the time taken for an order to ship and converting the no. of days in int format. */
select order_id,customer_id,customer_name,city,states, (ship_date-order_date) as delivery_duration
from store
order by delivery_duration desc

/* Calculate the time taken for an order to ship and converting the no. of days in int format. */
select order_id,customer_id,customer_name,city,states, (ship_date-order_date) as delivery_duration
from store
order by delivery_duration desc

/* Extract the year  for respective order ID and Customer ID with quantity. */
select order_id,customer_id,quantity,EXTRACT(YEAR from Order_Date) 
from store
group by order_id,customer_id,quantity,EXTRACT(YEAR from Order_Date) 
order by quantity desc


/* What is the Sales impact? */
SELECT EXTRACT(YEAR from Order_Date), Sales, round(cast(((profit/((sales-profit))*100))as numeric),2) as profit_percentage
FROM store
GROUP BY EXTRACT(YEAR from Order_Date), Sales, profit_percentage
order by  profit_percentage 
limit 20

--Breakdown by Top vs Worst Sellers:
-- Find Top 10 Categories (with the addition of best sub-category within the category).:
SELECT  Category, Sub_Category , round(cast(SUM(sales) as numeric),2) AS prod_sales
FROM store
GROUP BY Category,Sub_Category
ORDER BY prod_sales DESC;

--Find Top 10 Sub-Categories. :
SELECT round(cast(SUM(sales) as numeric),2) AS prod_sales,Sub_Category
FROM store
GROUP BY Sub_Category
ORDER BY prod_sales DESC
OFFSET 1 ROWS FETCH NEXT 10 ROWS ONLY;

--Find Worst 10 Categories.:
SELECT round(cast(SUM(sales) as numeric),2) AS prod_sales, Category, Sub_Category
FROM store
GROUP BY Category, Sub_Category
ORDER BY prod_sales;

-- Find Worst 10 Sub-Categories. :
SELECT round(cast(SUM(sales) as numeric),2) AS prod_sales, sub_Category
FROM store
GROUP BY Sub_Category
ORDER BY prod_sales
OFFSET 1 ROWS FETCH NEXT 10 ROWS ONLY;

/* Show the Basic Order information. */
select count(Order_ID) as Purchases,
round(cast(sum(Sales)as numeric),2) as Total_Sales,
round(cast(sum(((profit/((sales-profit))*100)))/ count(*)as numeric),2) as avg_percentage_profit,
min(Order_date) as first_purchase_date,
max(Order_date) as Latest_purchase_date,
count(distinct(Product_Name)) as Products_Purchased,
count(distinct(City)) as Location_count
from store

/* RETURN LEVEL ANALYSIS */
/* Find the number of returned orders. */
select Returned_items, count(Returned_items)as Returned_Items_Count
from store
group by Returned_items
Having Returned_items='Returned'

--Find Top 10 Returned Categories.:
SELECT Returned_items, Count(Returned_items) as no_of_returned ,Category, Sub_Category
FROM store
GROUP BY Returned_items,Category,Sub_Category
Having Returned_items='Returned'
ORDER BY count(Returned_items) DESC
limit 10;

-- Find Top 10  Returned Sub-Categories.:
SELECT Returned_items, Count(Returned_items),Sub_Category
FROM store
GROUP BY Returned_items, Sub_Category
Having Returned_items='Returned'
ORDER BY Count(Returned_items) DESC
OFFSET 1 ROWS FETCH NEXT 10 ROWS ONLY;

--Find Top 10 Customers Returned Frequently.:
SELECT Returned_items, Count(Returned_items) As Returned_Items_Count, Customer_Name, Customer_ID,Customer_duration, States,City
FROM store
GROUP BY Returned_items,Customer_Name, Customer_ID,customer_duration,states,city
Having Returned_items='Returned'
ORDER BY Count(Returned_items) DESC
limit 10;

-- Find Top 20 cities and states having higher return.
SELECT Returned_items, Count(Returned_items)as Returned_Items_Count,States,City
FROM store
GROUP BY Returned_items,states,city
Having Returned_items='Returned'
ORDER BY Count(Returned_items) DESC
limit 20;


--Check whether new customers are returning higher or not.
SELECT Returned_items, Count(Returned_items)as Returned_Items_Count,Customer_duration
FROM store
GROUP BY Returned_items,Customer_duration
Having Returned_items='Returned'
ORDER BY Count(Returned_items) DESC
limit 20;

--Find Top  Reasons for returning.
SELECT Returned_items, Count(Returned_items)as Returned_Items_Count,return_reason
FROM store
GROUP BY Returned_items,return_reason
Having Returned_items='Returned'
ORDER BY Count(Returned_items) DESC






