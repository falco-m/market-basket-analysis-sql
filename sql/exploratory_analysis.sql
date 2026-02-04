-- ========================================
-- UK ONLINE RETAIL ANALYSIS
-- Script 2: Exploratory Data Analysis
-- ========================================

USE Online_retail;

-- ========================================
-- 1. BUSINESS METRICS OVERVIEW
-- ========================================

SELECT 
    'Total Revenue' AS Metric,
    CONCAT('£ ', FORMAT(SUM(Quantity * UnitPrice), 2)) AS Value
FROM view_sales

UNION ALL

SELECT 
    'AOV (Average Order Value)',
    CONCAT('£ ', FORMAT(SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo), 2))
FROM view_sales

UNION ALL

SELECT 
    'Total Orders',
    FORMAT(COUNT(DISTINCT InvoiceNo), 0)
FROM view_sales

UNION ALL

SELECT 
    'Unique Customers',
    FORMAT(COUNT(DISTINCT CustomerID), 0)
FROM view_sales

UNION ALL

SELECT 
    'Avg Items per Order',
    FORMAT(AVG(items), 2)
FROM (
    SELECT COUNT(DISTINCT StockCode) AS items
    FROM view_sales
    GROUP BY InvoiceNo
) t

UNION ALL

SELECT 
    'Unique Products in Catalog',
    FORMAT(COUNT(DISTINCT StockCode), 0)
FROM view_sales

UNION ALL

SELECT 
    'Avg Spend per Customer',
    CONCAT('£ ', FORMAT(AVG(customer_spend), 2))
FROM (
    SELECT SUM(Quantity * UnitPrice) AS customer_spend
    FROM view_sales
    GROUP BY CustomerID
) c

UNION ALL

Select
'Average Basket Size' ,
ROUND(avg(BasketSize),0)
From	(Select 
		invoiceno,
		sum(quantity) as BasketSize
		from view_sales
		Group by invoiceno
		order by sum(quantity) desc
        )t

-- Expected output:
-- Total Revenue :  £8,779,659
-- AOV: £477.03
-- TotalOrders: 18,405
-- UniqueCustomers: 4,334
-- Avg Items per Orders : 21
-- Unique Products in Catalog : 3,661
-- Avg spend per Customer : £2,025.76
-- Aerage Basket size : 280

-- ========================================
-- 2. BASKET SIZE ANALYSIS
-- ========================================

-- Calculate unique items per order
WITH Basket_Size AS (
    SELECT 
        InvoiceNo,
        COUNT(DISTINCT StockCode) AS Items_in_Basket
    FROM view_sales
    GROUP BY InvoiceNo
),
Grouped_Basket AS (
    SELECT
        Items_in_Basket,
        COUNT(Items_in_Basket) AS Numb_of_Orders
    FROM Basket_Size
    GROUP BY Items_in_Basket
)
SELECT
    Items_in_Basket,
    Numb_of_Orders,
    ROUND(Numb_of_Orders * 100.0 / SUM(Numb_of_Orders) OVER (), 2) AS Pct_of_Total_Orders,
    ROUND(SUM(Numb_of_Orders) OVER (ORDER BY Items_in_Basket) * 100.0 / SUM(Numb_of_Orders) OVER(), 2) AS Cumulative_Distribution
FROM Grouped_Basket
ORDER BY Items_in_Basket ASC;

-- Key Insight: 
-- 80% of orders have >5 unique items
-- 50% of orders have >14 unique items
