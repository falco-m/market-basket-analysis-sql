-- ========================================
-- UK ONLINE RETAIL ANALYSIS
-- Script 4: RFM Customer Segmentation
-- ========================================
-- Objective: Segment customers by Recency, Frequency, Monetary
-- and identify churn risk using interpurchase time analysis
-- ========================================

USE Online_retail;

-- ========================================
-- 1. BUILD RFM TABLE WITH ADVANCED METRICS
-- ========================================

CREATE OR REPLACE VIEW view_rfm_analysis AS
WITH 
-- Get reference date (last date in dataset + 1 day)
max_date_ref AS (
    SELECT MAX(InvoiceDate) AS max_date
    FROM view_sales
),

-- Aggregate at invoice level
invoice_summary AS (
    SELECT
        CustomerID,
        InvoiceNo,
        DATE(InvoiceDate) AS InvoiceDate,
        SUM(Quantity * UnitPrice) AS InvoiceValue
    FROM view_sales
    GROUP BY CustomerID, InvoiceNo, DATE(InvoiceDate)
),

-- Calculate interpurchase time using LAG window function
order_gaps AS (
    SELECT 
        CustomerID,
        InvoiceNo,
        InvoiceDate,
        InvoiceValue,
        LAG(InvoiceDate) OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS PrevInvoiceDate,
        DATEDIFF(
            InvoiceDate, 
            LAG(InvoiceDate) OVER (PARTITION BY CustomerID ORDER BY InvoiceDate)
        ) AS DaysSinceLastOrder
    FROM invoice_summary
)

-- ========================================
-- 2. AGGREGATE AT CUSTOMER LEVEL
-- ========================================

SELECT 
    t.CustomerID,
    
    -- RECENCY: Days since last purchase
    DATEDIFF((SELECT max_date FROM max_date_ref), MAX(t.InvoiceDate)) AS Recency_Days,
    
    -- FREQUENCY: Number of orders
    COUNT(DISTINCT t.InvoiceNo) AS Frequency_Orders,
    
    -- MONETARY: Total spend
    ROUND(SUM(t.InvoiceValue), 2) AS Monetary_Total,
    
    --  Average days between orders
    COALESCE(ROUND(AVG(t.DaysSinceLastOrder), 1), 0) AS Avg_Days_Between_Orders,
    
    -- Customer tenure (days from first to last purchase)
    DATEDIFF(MAX(t.InvoiceDate), MIN(t.InvoiceDate)) AS Tenure_Days

FROM order_gaps t
GROUP BY t.CustomerID
ORDER BY Monetary_Total DESC;


-- ========================================
-- 3. SEGMENT CUSTOMERS BY BEHAVIOR (DYNAMIC THRESHOLDS)
-- ========================================

WITH rfm_data AS (
    SELECT * FROM view_rfm_analysis
)

SELECT 
    CASE 
        WHEN Frequency_Orders = 1 THEN 'One-Shot'
        WHEN Recency_Days > (Avg_Days_Between_Orders * 3) THEN 'Churned'
        WHEN Recency_Days > (Avg_Days_Between_Orders * 1.5) THEN 'Alert'
        ELSE 'Active'
    END AS Customer_Segment,
    COUNT(*) AS Customer_Count,
    Concat(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2), '%') AS Customer_Percentage,
    Concat('£ ',ROUND(AVG(Monetary_Total), 2)) AS Avg_Lifetime_Value,
    ROUND(AVG(Frequency_Orders), 1) AS Avg_num_Orders,
    Concat('£ ',ROUND(SUM(Monetary_Total), 2)) AS Segment_Total_Revenue
FROM rfm_data
GROUP BY Customer_Segment
ORDER BY Segment_Total_Revenue DESC;

-- KEY INSIGHTS 

-- ✓ Active & Regular (50.58%): STRONG CORE BASE
--   → Half of customers follow consistent purchase patterns
--   → Action: Introduce subscription models for top repeat buyers

-- ⚠ One-Shot Customers (34.73%): MAJOR CONVERSION OPPORTUNITY
--   → 1 in 3 customers never return after first purchase
--   → Action: Automated email sequence (Day 3, 7, 14 post-purchase)
--   → Action: First-reorder incentive (10% discount + free shipping)
--   → Potential impact: Converting 10% = +150 retained customers

-- ⚠ Alert Customers (6.67%): PREVENTABLE CHURN
--   → Small but critical group showing early warning signs
--   → Action: "We miss you" campaign with personalized product recommendations


-- ✗ Churned Customers (8.03%): WIN-BACK CAMPAIGN TARGET
--   → Lost customers who exceeded 3x their purchase cycle
--   → Action: Aggressive win-back offer (15-20% discount)


-- ────────────────────────────────────────────────────────
-- STRATEGIC PRIORITIES:
-- 1. Fix the One-Shot problem → Biggest revenue leak
-- 2. Protect the 50% Active base → Retention > Acquisition
-- 3. Rescue Alert customers before they churn → Lowest cost intervention
