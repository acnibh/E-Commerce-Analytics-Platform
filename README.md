# [SQL] E-Commerce Analytics Platform

## I. Project Overview
Develop a database for an e-commerce platform. It will include customer data, product information, sales transactions, and inventory management. This project will 
show my complex queries for analyzing sales trends, customer behavior, and inventory management.

## II. Database Structure
- Customers: CustomerID, Name, Email, RegistrationDate, Location
- Products: ProductID, Name, Category, Price, SupplierID, StockQuantity
- Orders: OrderID, CustomerID, OrderDate, TotalAmount
- OrderDetails: OrderDetailID, OrderID, ProductID, Quantity, UnitPrice
- Suppliers: SupplierID, Name, ContactInfo, ProductType

## III. Exploring the Dataset
In this project, "I will write 8 queries regarding the analysis of sales trends, customer behavior, and inventory management to generate a report.
### Tools
- SQL Server - Data Analysis
### Query 01: Find the total sales amount for each customer.
#### SQL Code
```sql
SELECT customers.CustomerID,
       Name,
	   SUM(TotalAmount) AS Total_Sales
FROM orders 
JOIN customers
ON orders.CustomerID = customers.CustomerID
GROUP BY customers.CustomerID, Name
```
#### Query Results
![image](https://github.com/acnibh/E-Commerce-Analytics-Platform/assets/146699917/eb7ff28b-4ce6-4bca-b3cd-34124b01e0a4)

### Query 02: Identify monthly sales totals.
#### SQL Code
```sql
SELECT YEAR(OrderDate) AS [Year],
       MONTH(OrderDate) AS [Month],
	   SUM (TotalAmount) AS TotalSales
FROM orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY YEAR(OrderDate) DESC, MONTH(OrderDate) ASC
```
#### Query Results
![image](https://github.com/acnibh/E-Commerce-Analytics-Platform/assets/146699917/b39ce523-429f-418a-9425-c342a954d0f2)

### Query 03: List the average, minimum, and maximum prices of products ordered by each customer, along with the total number of orders.
#### SQL Code
```sql
WITH joined_table AS (
SELECT CustomerID,
       detail.OrderID,
	   UnitPrice
FROM order_details AS detail
JOIN orders AS ord
ON detail.OrderID = ord.OrderID

) 
SELECT CustomerID,
       MAX(UnitPrice) AS MaxPrice,
	   MIN(UnitPrice) AS MinPrice,
	   CAST (AVG(UnitPrice) AS DECIMAL(10,2)) AS AvgPrice
FROM joined_table
GROUP BY customerID
```
#### Query Results
![image](https://github.com/acnibh/E-Commerce-Analytics-Platform/assets/146699917/973aeac3-5ef9-46cc-9643-0a6d05b693d9)

### Query 04: Calculate the monthly sales totals for the current year, broken down by product category.
#### SQL Code
```sql
SELECT YEAR(OrderDate) AS [year],
       MONTH (OrderDate) AS [Month],
       Category,
			 SUM(TotalAmount) Total_Sales
FROM order_details AS detail
JOIN orders AS ord
ON detail.OrderID = ord.OrderID
JOIN products AS pro
ON detail.ProductID = pro.ProductID
GROUP BY YEAR(OrderDate), MONTH(OrderDate), Category
HAVING YEAR(OrderDate) = 2023
RDER BY Month(OrderDate) ASC
```
#### Query Results
![image](https://github.com/acnibh/E-Commerce-Analytics-Platform/assets/146699917/263999d6-b799-455c-a437-f38661eab9c0)

### Query 05: Find the top 3 most popular product categories based on the number of orders.
#### SQL Code
```sql
SELECT TOP 3 Category,
	            SUM(Quantity) AS Quantity
     FROM order_details AS t1
     LEFT JOIN products AS t2
     ON t1.ProductID = t2.ProductID
     GROUP BY Category
	 ORDER BY SUM(Quantity) DESC
```
#### Query Results
![image](https://github.com/acnibh/E-Commerce-Analytics-Platform/assets/146699917/368caaaf-5f79-448a-8d83-37ddadec01e7)

### Query 06: Find all products that have a price above the average price of products in their category.
#### SQL Code
```sql
WITH join_table AS (
SELECT ProductID,
       Name,
	  Category,
	   Price,
	   AVG(Price) OVER ( Partition BY Category ) AS Avg_Price_Category
FROM products
)
SELECT * FROM join_table
WHERE Price > Avg_Price_Category
```
#### Query Results
![image](https://github.com/acnibh/E-Commerce-Analytics-Platform/assets/146699917/7bfba373-74a6-4942-9268-835c57503697)

### Query 07: Identify customers who have only ordered products from one specific category (e.g., 'Electronics').
#### SQL Code
```sql
WITH joined_table AS (
SELECT ord.CustomerID,
       Cus.Name
FROM order_details AS detail
JOIN products AS pro
ON detail.ProductID = pro.ProductID
JOIN orders AS ord
ON detail.OrderID = ord.OrderID
JOIN customers AS cus
ON ord.CustomerID = Cus.CustomerID
GROUP BY ord.CustomerID, Cus.Name
HAVING COUNT( DISTINCT Category) = 1
) 
SELECT DISTINCT joined.CustomerID,
       joined.Name,
	   Category
FROM joined_table AS joined
JOIN orders AS t1
ON t1.CustomerID = joined.CustomerID
JOIN products AS t2
ON t1.CustomerID = joined.CustomerID
WHERE Category = 'Electronics'
```
#### Query Results
![image](https://github.com/acnibh/E-Commerce-Analytics-Platform/assets/146699917/f0daa3b2-9ac4-4c8f-a15d-fdda6d984cec)

### Query 08: List all products that have never been ordered.
#### SQL Code
```sql
SELECT ProductID,
       Category,
       Name
FROM products
WHERE ProductID NOT IN ( SELECT ProductID
                         FROM order_details )
```
#### Query Results
![image](https://github.com/acnibh/E-Commerce-Analytics-Platform/assets/146699917/5dc71bd8-ae2c-48c1-bfc9-907d69e8b7ae)

## IV. Conclusion
In conclusion, my exploration of the e-commerce platform using SQL has revealed several interesting insights.
By exploring  e-commerce platform, I have gained valuable information about sales trends, customer behavior, and inventory management,.... which could inform future business decisions.
To deep dive into the insights and key trends, the next step will visualize the data with some software like Power BI,Tableau,...
Overall, this project has demonstrated the power of using SQL and big data tools to gain insights into large datasets.













