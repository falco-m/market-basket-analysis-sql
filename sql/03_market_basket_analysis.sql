-- ========================================
-- UK ONLINE RETAIL ANALYSIS
-- Script 3: Market Basket Analysis
-- ========================================
-- Objective: Identify products frequently purchased together
-- to create bundling opportunities and increase AOV
-- ========================================

USE Online_retail;

-- ========================================
-- 1. PREPARE ANALYSIS TABLE WITH INDEXING
-- ========================================

-- Create physical table for better performance
CREATE TABLE analysis_sales AS
SELECT * 
FROM view_sales;

-- Add composite index to speed up self-join
CREATE INDEX idx_invoice_stock ON analysis_sales (InvoiceNo, StockCode);

-- ========================================
-- 2. IDENTIFY TOP PRODUCT PAIRS (SELF-JOIN)
-- ========================================

WITH top_pairs AS (
    SELECT 
        v1.StockCode AS Code_A,
        v2.StockCode AS Code_B,
        COUNT(*) AS Frequency,
        SUM((v1.Quantity * v1.UnitPrice) + (v2.Quantity * v2.UnitPrice)) AS Pair_Total_Revenue
    FROM analysis_sales v1
    -- Self-join: Match products from same invoice. 
    -- Making a self-join allow us to create another table with the stock-code excluding the duplicate 
    -- using stockcode < stockcode (example: stockA - stockA)
    JOIN analysis_sales v2
        ON v1.InvoiceNo = v2.InvoiceNo
        AND v1.StockCode < v2.StockCode  -- Prevent duplicates (A+B = B+A)
    WHERE v1.InvoiceNo NOT IN (
        -- Exclude outlier bulk orders (>50 items)
        SELECT InvoiceNo 
        FROM analysis_sales 
        GROUP BY InvoiceNo 
        HAVING COUNT(*) > 50
    )
    GROUP BY v1.StockCode, v2.StockCode
    HAVING COUNT(*) > 100  -- Minimum frequency threshold
),
-- Get clean product names
-- created the product_names table to obtain the description of every stockcode 
-- ( i didn't put the description field in the select statement in top_pairs because 20 rows were missing caused by the way that the description field is written)
product_names AS (
    SELECT 
        StockCode, 
        MAX(Description) AS Product_Name
    FROM analysis_sales
    GROUP BY StockCode
)

-- ========================================
-- 3. FINAL OUTPUT: TOP PRODUCT BUNDLES
-- ========================================

SELECT 
    Code_A,
    n1.Product_Name AS Product_Name_A,
    Code_B,
    n2.Product_Name AS Product_Name_B,
    Frequency,
    ROUND(Pair_Total_Revenue, 2) AS Pair_Total_Revenue,
    ROUND(Pair_Total_Revenue / Frequency, 2) AS Avg_Pair_Value
FROM top_pairs
JOIN product_names n1 ON Code_A = n1.StockCode
JOIN product_names n2 ON Code_B = n2.StockCode
ORDER BY Pair_Total_Revenue DESC
LIMIT 20;

-- ========================================
-- KEY FINDINGS:
-- ========================================
-- Top Bundle #1: JUMBO BAG RED RETROSPOT + JUMBO BAG STRAWBERRY
--    - Revenue: £50,000+
--    - Frequency: 321 co-purchases
--    - Recommendation: Create "Jumbo Bag Duo" bundle with 5% discount

-- Top Bundle #2: JUMBO BAG RED RETROSPOT + JUMBO BAG PINK POLKADOT
--    - Revenue: £49,000+
--    - Frequency: 425 co-purchases
--    - Recommendation: "Jumbo Bag Duo 2" bundle with 5% discount

-- Top Bundle #3: REGENCY CAKESTAND 3 TIER + ROSES REGENCY TEACUP
--    - Revenue: £42,000+
--    - Frequency: 340 co-purchases
--    - Recommendation: "Regency Tea Set" bundle
