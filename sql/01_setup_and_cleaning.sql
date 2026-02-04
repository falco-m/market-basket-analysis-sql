-- ========================================
-- UK ONLINE RETAIL ANALYSIS
-- Script 1: Database Setup & Data Cleaning
-- ========================================

-- ========================================
-- 1. CREATE MAIN TABLE
-- ========================================

CREATE TABLE retail_data (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10, 2),
    CustomerID INT NULL,
    Country VARCHAR(50)
);

-- ========================================
-- 2. LOAD DATA FROM CSV
-- ========================================

LOAD DATA LOCAL INFILE '/Users/falco/Documents/Data Analyst/Projects/Online Retail.csv'
INTO TABLE retail_data
CHARACTER SET latin1  
FIELDS TERMINATED BY ';'        
ENCLOSED BY '"'                
LINES TERMINATED BY '\n'        
IGNORE 1 ROWS                 
(
    InvoiceNo, 
    StockCode, 
    Description, 
    Quantity, 
    @VarInvoiceDate,
    @VarUnitPrice,
    CustomerID, 
    Country
)
SET 
    -- Transform date from '01/12/10 08:26' to MySQL format
    InvoiceDate = STR_TO_DATE(@VarInvoiceDate, '%d/%m/%y %H:%i'),
    
    -- Transform price: replace comma with dot
    UnitPrice = CAST(REPLACE(@VarUnitPrice, ',', '.') AS DECIMAL(10,2));

-- ========================================
-- 3. CREATE CLEANED VIEWS
-- ========================================

-- View 1: Sales Only (excludes returns and invalid records)
CREATE OR REPLACE VIEW view_sales AS
SELECT *
FROM retail_data
WHERE Quantity > 0
  AND InvoiceNo NOT LIKE 'C%' 
  AND StockCode NOT IN ('D', 'M', 'POST', 'BANK CHARGES', 'CRUK') -- Exclusion of discounts, etc..
  AND UnitPrice > 0 -- Exclusion of bad debt and errors
  AND CustomerID > 0 
  AND CustomerID IS NOT NULL;

-- View 2: Returns Only (for separate analysis)
CREATE OR REPLACE VIEW view_product_returns AS
SELECT *
FROM retail_data
WHERE InvoiceNo LIKE 'C%'
  AND StockCode NOT IN ('D', 'M', 'POST', 'BANK CHARGES', 'CRUK')
  AND UnitPrice > 0;

