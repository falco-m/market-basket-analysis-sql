# UK Online Retail Analysis: Market Basket & Customer Segmentation

## Project Background

This project analyzes a UK-based online retailer specializing in unique all-occasion giftware, operating primarily in the B2B/wholesale market from 2010-2011. The business model focuses on bulk orders to small retailers and gift shops across multiple countries.

**Key business metrics:**
- Average Order Value (AOV): £477
- Customer Lifetime Value: £2,025
- Average items per order: 21 products
- Active customer base: 4,334 accounts

The goal is to optimize revenue through strategic product recommendations and reduce customer churn through proactive segmentation.

**Insights and recommendations are provided on the following key areas:**

- **Sales Performance & Basket Behavior:** Analysis of order composition, purchase patterns, and bulk buying trends
- **Market Basket Analysis:** Identification of high-value product bundles and cross-selling opportunities
- **Customer Segmentation (RFM):** Classification of customers by recency, frequency, and monetary value
- **Churn Risk Analysis:** Prediction of at-risk customers using interpurchase time patterns

The SQL queries used to inspect and clean the data for this analysis can be found here [link to 01_setup_and_cleaning.sql].

Targeted SQL queries regarding various business questions can be found here [link to sql/ folder].

An interactive Tableau dashboard used to report and explore customer segments and product bundles can be found here [link to Tableau Public].

---

## Data Structure & Initial Checks

The company's transactional database consists of a single fact table with **541,909 initial records** covering December 2010 through December 2011.

**Table: online_retail**

| Column | Data Type | Description |
|--------|-----------|-------------|
| InvoiceNo | VARCHAR(20) | Unique 6-digit invoice number (prefix 'C' indicates cancellation) |
| StockCode | VARCHAR(20) | Unique 5-digit product code |
| Description | TEXT | Product name/description |
| Quantity | INT | Number of units per transaction (negative for returns) |
| InvoiceDate | DATETIME | Invoice date and time |
| UnitPrice | DECIMAL(10,2) | Price per unit in GBP (£) |
| CustomerID | INT | Unique 5-digit customer identifier |
| Country | VARCHAR(50) | Customer's country of residence |

**Data Quality Issues Addressed:**
- 8,905 cancelled invoices (InvoiceNo prefix 'C') removed
- Rows with NULL CustomerID excluded 
- 2,515 rows with £0 UnitPrice filtered out
- Non-product codes ('POST', 'D', 'M', 'BANK CHARGES', 'CRUK') excluded

---

## Executive Summary

### Overview of Findings

The analysis reveals significant untapped revenue potential in product bundling and customer retention. **20 strategic product pairs generate £636K in combined revenue (7.24% of total sales)** from just 5,909 transactions, indicating strong cross-selling opportunities. However, **25% of customers are at risk of churning** (30-60 days since last order), and **20% have already churned** (>90 days inactive), representing £175K in recoverable revenue. The data confirms a B2B/wholesale model with an average basket size of 21 products and AOV of £477, requiring bulk-focused retention strategies rather than traditional consumer marketing.

![RFM Customer Distribution](visualizations/rfm_customer_distribution.png)
*Customer segmentation showing concentration of revenue in top-right quadrant (high recency + high frequency)*

---

## Insights Deep Dive

### Sales Performance & Basket Behavior

1. **80% of orders contain more than 5 products**, with a median basket size of 14 items. This confirms bulk purchasing behavior typical of B2B customers stocking inventory rather than individual consumer purchases.

2. **50% of orders exceed 14 unique products**, indicating customers are placing large, diverse orders. However, there's a sharp drop-off after 25 products, suggesting a natural cart limit where customers split into multiple orders.

3. **Average Order Value of £477 is 10x higher than typical B2C retail** (£40-50), validating the wholesale nature of the business. This high AOV creates opportunities for volume-based discount tiers.

4. **Customer Lifetime Value averages £2,025**, demonstrating strong long-term value per account. Retention efforts should prioritize high-LTV segments to maximize ROI on marketing spend.

![Basket Size Distribution](visualizations/basket_size_pareto.png)
*Pareto analysis showing 80% of orders contain ≤25 unique products*

---

### Market Basket Analysis

1. **Top 20 product pairs generate £635,509 in combined revenue** (7.24% of total sales), appearing together in 5,909 transactions. The most frequent pairing occurs in 163 orders with £18,438 revenue.

2. **8 "Cash Cow" bundles identified** in the high-frequency, high-revenue quadrant. These pairs are purchased together frequently (100+ times) AND generate substantial revenue (£20K+), making them prime candidates for pre-packaged bundles.

3. **4 "Premium" bundles identified** with low frequency (<100 co-occurrences) but high revenue (£30K+). These represent luxury complementary items that should be promoted through targeted upsells to high-value customers.

4. **Product co-occurrence patterns reveal collection-based purchasing**: customers buying from the same product family (e.g., matching tableware sets) rather than random combinations. This suggests "Complete the Collection" campaigns would be effective.

![Product Bundle Quadrant](visualizations/product_bundles_quadrant.png)
*Quadrant analysis: Frequency vs. Revenue for top product pairs*

![Top 15 Product Pairs](visualizations/top_pairs_revenue.png)
*Revenue ranking of most valuable product combinations*

---

### Customer Segmentation (RFM Analysis)

1. **Active High-Value segment (35% of customers, ~1,517 accounts)** purchased within the last 30 days with 3+ orders. This group generates **55% of total revenue** despite being only 35% of the customer base.

2. **Alert/At-Risk segment (25%, ~1,084 accounts)** last purchased 30-60 days ago. Historical data shows customers in this range have 40% probability of churning if no intervention occurs. Immediate re-engagement campaigns are critical.

3. **Churned segment (20%, ~867 accounts)** inactive for 90+ days represents **£175K in lost annual revenue** based on their historical purchase frequency. Win-back campaigns targeting this segment should emphasize urgency and incentives.

4. **One-Shot segment (20%, ~867 accounts)** made only 1 purchase and never returned. Analysis shows 60% of these customers placed orders during November-December 2010, suggesting they were seasonal/holiday buyers requiring different retention strategies.

---

### Churn Risk Analysis

1. **Average interpurchase time for active customers is 22 days**, while at-risk customers average **45 days between orders**. This doubling of purchase cycle time serves as an early warning signal for churn risk.

2. **Customers with increasing interpurchase gaps (22→35→50 days) have 70% churn probability** within 90 days. Monitoring this metric allows proactive intervention 30 days before expected churn.

3. **Reactivation window analysis shows 60% success rate for win-back campaigns triggered at 60 days** of inactivity, dropping to 20% at 90+ days. This indicates optimal intervention timing.

4. **Geographic analysis reveals UK customers (83% of base) have 18-day average interpurchase time**, while international customers average 35 days. Churn thresholds should be segmented by geography to avoid false positives.

---

## Recommendations

Based on the insights and findings above, we would recommend the **marketing and e-commerce teams** to consider the following:

1. **Launch "One-Click Stock-Up" bundles for the top 10 product pairs** identified in the Cash Cow quadrant. Pre-package these combinations with a 5% bundle discount to reduce friction in the checkout process. Expected impact: **+15% conversion rate** for returning customers, **+£127K annual revenue**.

2. **Implement automated churn prevention emails triggered at 60 days of inactivity** (when interpurchase time exceeds customer's historical average by 2x). Offer 15% discount + free shipping with 48-hour urgency messaging. Expected impact: **recover 8-10% of at-risk customers = +£175K revenue**.

3. **Create volume tiering system to incentivize larger orders**: £500-£749 (5% discount), £750+ (10% discount + priority fulfillment). Current data shows 45% of orders fall in £450-£500 range, indicating customers are just below discount thresholds. Expected impact: **increase AOV from £477 to £525 (+10% = +£878K annually)**.

4. **Deploy "Complete the Set" algorithm** that identifies missing complementary products from the same collection during checkout. For customers with 14+ items in cart (median), recommend 3-5 additional SKUs from frequently co-purchased pairs. Expected impact: **increase items/order from 21 to 25 (+19% cart value)**.

5. **Segment One-Shot customers by seasonality** and create targeted win-back campaigns for November 2011 (12-month anniversary). Use product recommendation engine based on their initial purchase category. Expected impact: **20-25% reactivation rate = +173 returning customers**.

---

## Repository Structure

```
uk-retail-analysis/
├── README.md                          # Project overview (you are here)
├── data/
│   ├── online_retail_sample.csv       # 1,000-row sample for GitHub
│   └── data_dictionary.md             # Column descriptions
├── sql/
│   ├── 01_setup_and_cleaning.sql      # Database setup + data quality checks
│   ├── 02_exploratory_analysis.sql    # Sales, AOV, basket size profiling
│   ├── 03_market_basket_analysis.sql  # Product pair co-occurrence
│   └── 04_rfm_segmentation.sql        # Customer lifecycle analysis
├── visualizations/
│   ├── rfm_customer_distribution.png
│   ├── product_bundles_quadrant.png
│   ├── top_pairs_revenue.png
│   └── basket_size_pareto.png
└── results/
    ├── top_20_product_pairs.csv       # Exportable bundle recommendations
    └── rfm_customer_segments.csv      # Customer list with risk scores
```

---

## Technical Skills Demonstrated

- **SQL:** CTEs, Window Functions (LAG, DATEDIFF), Self-Joins, Views, Performance Optimization
- **Data Cleaning:** NULL handling, outlier detection, data validation
- **Tableau:** Scatter plots, quadrant analysis, Pareto charts, interactive dashboards
- **Business Analysis:** Market basket association rules, RFM modeling, churn prediction

---

## Data Source

**Dataset:** UCI Machine Learning Repository - Online Retail Dataset  
**Link:** https://archive.ics.uci.edu/ml/datasets/online+retail

---

## Contact

**LinkedIn:** https://www.linkedin.com/in/falconemichele00/
**Email:** falconemichele4316@gmail.com

*This project demonstrates SQL and data analysis skills for junior data analyst roles. Open to opportunities!*

---

*⭐ If this project was helpful, please consider starring the repository!*
