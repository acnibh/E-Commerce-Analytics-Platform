--Querry 01: Find the total sales amount for each customer.
 SELECT customers.CustomerID,
       Name,
	   SUM(TotalAmount) AS Total_Sales
FROM orders 
JOIN customers
ON orders.CustomerID = customers.CustomerID
GROUP BY customers.CustomerID, Name

--Querry 02: Identify monthly sales totals.
SELECT YEAR(OrderDate) AS [Year],
       MONTH(OrderDate) AS [Month],
	   SUM (TotalAmount) AS TotalSales
FROM orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY YEAR(OrderDate) DESC, MONTH(OrderDate) ASC

--Querry 03: List the average, minimum, and maximum prices of products ordered by each customer, along with the total number of orders.
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

--Querry 04: Calculate the monthly sales totals for the current year, broken down by product category.
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
	 ORDER BY Month(OrderDate) ASC

--Querry 05: Find the top 3 most popular product categories based on the number of orders.
SELECT TOP 3 Category,
	            SUM(Quantity) AS Quantity
     FROM order_details AS t1
     LEFT JOIN products AS t2
     ON t1.ProductID = t2.ProductID
     GROUP BY Category
	 ORDER BY SUM(Quantity) DESC

--Querry 06: Find all products that have a price above the average price of products in their category.
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


--Querry 07: Identify customers who have only ordered products from one specific category (e.g., 'Electronics')
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

--Querry 08: List all products that have never been ordered.
SELECT ProductID,
       Category,
       Name
FROM products
WHERE ProductID NOT IN ( SELECT ProductID
                         FROM order_details )

