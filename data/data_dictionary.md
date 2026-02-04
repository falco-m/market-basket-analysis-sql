# Data Dictionary

## Dataset: UK Online Retail Transactions (Dec 2010 - Dec 2011)

### Source
- **Original Dataset**: [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/online+retail)
- **Size**: 541,909 transactions
- **Period**: 01/12/2010 - 09/12/2011

### Schema

| Column Name | Data Type | Description | Example |
|-------------|-----------|-------------|---------|
| `InvoiceNo` | VARCHAR(20) | Unique invoice identifier. Invoices starting with 'C' indicate cancellations/returns | 536365 |
| `StockCode` | VARCHAR(20) | Unique product identifier | 85123A |
| `Description` | VARCHAR(255) | Product name/description | WHITE HANGING HEART T-LIGHT HOLDER |
| `Quantity` | INT | Number of units purchased. Negative values indicate returns | 6 |
| `InvoiceDate` | DATETIME | Transaction timestamp | 01/12/2010 08:26 |
| `UnitPrice` | DECIMAL(10,2) | Price per unit in GBP (£) | 2.55 |
| `CustomerID` | INT | Unique customer identifier. NULL for guest purchases | 17850 |
| `Country` | VARCHAR(50) | Customer country | United Kingdom |


