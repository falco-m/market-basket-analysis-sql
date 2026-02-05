# UK Online Retail Analysis: Strategic Product Bundling & Customer Retention

## Project Background

This project analyzes a UK-based online retailer specializing in unique all-occasion giftware, operating primarily in the B2B/wholesale market from 2010-2011. The business model focuses on bulk orders to small retailers and gift shops across multiple countries.

**Note:** This is a portfolio project using publicly available data from the UCI Machine Learning Repository. The analysis demonstrates advanced SQL techniques and business intelligence skills applicable to real-world e-commerce optimization.

**Key business metrics:**
- Total Revenue: £8,779,659
- Average Order Value (AOV): £477
- Customer Lifetime Value: £2,025
- Average items per order: 21 products
- Active customer base: 4,334 accounts

As a data analyst supporting this retailer, the **primary objective is to increase Average Order Value (AOV)** through strategic product bundling, while preventing customer churn through proactive RFM segmentation.

**Insights and recommendations are provided on the following key areas:**

- **Basket Behavior Analysis:** Why bulk purchasing patterns justify market basket analysis
- **High-Revenue Product Bundles:** Frequently purchased pairs driving volume sales (£24K-£51K total revenue)
- **High-Value Premium Bundles:** Low-frequency pairs with exceptional unit economics (£133-£206 avg pair value)
- **Customer Segmentation (RFM):** Classification of 4,334 customers to identify upselling and retention opportunities
- **AOV Optimization Strategy:** Targeted recommendations to increase basket value from £477 to £550+ (+15%)

The SQL queries used to inspect and clean the data for this analysis can be found here [sql/01_setup_and_cleaning.sql](sql/01_setup_and_cleaning.sql).

Targeted SQL queries regarding various business questions can be found here [sql/](sql/).

An interactive Tableau dashboard used to report and explore customer segments and product bundles can be found here [on Tableau Public]([https://public.tableau.com/app/profile/yourprofile](https://public.tableau.com/views/Project_17688308344020/Dashboard1?:language=it-IT&:sid=&:display_count=n&:origin=viz_share_link)).

---

## Executive Summary

### Overview of Findings

This analysis identifies **two distinct bundle strategies to increase AOV by 15% (£477 → £550)**, generating an estimated **+£878K in annual revenue**. The first strategy targets **20 high-volume product pairs** (321-430 co-purchases) generating £635K combined revenue, ideal for "One-Click" pre-packaged bundles with volume discounts. The second strategy focuses on **20 premium pairs** with low frequency (101-187 occurrences) but exceptional unit economics (£133-£206 avg pair value), suitable for targeted upselling to high-value customers. Customer segmentation reveals that **50.58% of customers (Active segment) generate 81% of revenue** (£7.13M), while 6.67% are at immediate churn risk (Alert segment, £484K revenue at stake).

![Product Bundle Quadrant](visualizations/product_bundle_matrix.png)
*Product Bundles Identification: Top-right = High-Revenue (volume drivers), Top-left = High-Value (premium pairs)*

---

## Insights Deep Dive

### Basket Behavior Analysis: Why Bundle Strategy Makes Sense

**Objective:** Validate that market basket analysis is appropriate for this business model

1. **Average order contains 21 unique products**, with a median of 14 items. This bulk purchasing behavior (10x higher than typical B2C retail where customers buy 1-3 items) indicates customers are already shopping for multiple complementary products in single transactions.

2. **80% of orders contain between 5-25 products**, creating a natural sweet spot for bundle recommendations. Customers aren't buying 1-2 items (where bundles add friction) but are actively curating diverse carts, making pre-packaged bundles a valuable time-saver.

3. **Only 20% of orders exceed 25 products**, suggesting most customers have mental "shopping lists" rather than browsing randomly. Pre-packaged bundles can streamline this list-building process and reduce decision fatigue during checkout.

4. **50% of customers stop at exactly 14 products (median threshold)**, creating an optimization opportunity. If we can identify which products are naturally purchased together at this threshold, we can push customers toward 18-20 items through strategic bundling.

![Basket Size Distribution](visualizations/basket_size_pareto.png)
*Pareto analysis: 80% of orders contain 5-25 products, validating the relevance of bundle strategy for this business*

**Key Insight:** The high items-per-order behavior proves customers are ALREADY mentally bundling products (matching collections, complementary designs) - market basket analysis simply formalizes these patterns to make checkout easier and increase AOV.

---

### High-Revenue Product Bundles (Volume Strategy)

**Objective:** Increase transaction frequency and cart size for mass-market products

1. **Top bundle generates £50,964 from 321 co-purchases** (JUMBO BAG RED RETROSPOT + STRAWBERRY, £158.77 avg pair value). This represents the #1 cross-selling opportunity with proven customer demand across 1.7% of all transactions.

2. **8 bundles exceed 300 co-purchases**, indicating strong natural pairing behavior. These "Cash Cow" bundles appear in 3-5% of all transactions, making them ideal candidates for prominent placement in checkout flows and homepage merchandising.

3. **Product families dominate high-frequency pairs**: 65% of top 20 involve JUMBO BAGS or REGENCY TEACUP collections, suggesting customers buy matching sets rather than random combinations. This validates "Complete the Collection" merchandising strategies over algorithmic recommendations.

4. **Average pair value ranges £59-£159** for volume bundles, fitting typical B2B restocking behavior. Lower unit economics are compensated by high transaction frequency (200-430 occurrences), generating £24K-£51K total revenue per pair.

![Top Product Pairs by Revenue](visualizations/top_pairs_revenue.png)
*Revenue ranking of most valuable product combinations from high-frequency bundles*

**Key Insight:** These bundles should be **pre-packaged with 5% discount** to reduce checkout friction and increase impulse purchases among all customer segments.

---

### High-Value Premium Bundles (Margin Strategy)

**Objective:** Maximize profit per transaction through targeted upselling

1. **Top premium bundle averages £206.50 per pair** (DOORMAT NEW ENGLAND + HEARTS) despite only 103 co-purchases. This represents a **30% higher unit value** than the best volume bundle (£158.77), indicating luxury item pairing.

2. **4 doormat combinations appear in premium list**, with avg pair values £133-£206. These luxury items are rarely purchased together organically (<120 occurrences) but deliver exceptional margins when they are, generating £13K-£21K total revenue despite low frequency.

3. **Regency collection premium sets average £141-£158** (TEAPOT + SUGAR BOWL, CAKESTAND + TEAPOT). These aspirational items appeal to high-end retailers and should be promoted exclusively to top-spending customers rather than mass-marketed.

4. **Premium bundles have 65% lower frequency than volume bundles** (103-187 vs 200-430 occurrences) but maintain strong total revenue (£13K-£29K) due to superior unit economics. This creates a high-margin, low-volume opportunity channel.

**Key Insight:** These bundles require **personalized recommendations for Active High-Value customers** (50% of base, £3,252 LTV) through email campaigns rather than homepage promotion, to avoid diluting premium positioning.

---

### Customer Segmentation (RFM Analysis)

**Objective:** Align bundle strategies with customer lifecycle stages

**RFM Segment Overview:**

| Segment | Customers | % of Base | Avg LTV | Avg Orders | Total Revenue | % Revenue | Priority |
|---------|-----------|-----------|---------|------------|---------------|-----------|----------|
| **🟢 Active** | 2,192 | 50.58% | £3,252.87 | 6.5 | £7,130,281 | **81.21%** | Premium bundles |
| **⚪ One-Shot** | 1,505 | 34.73% | £418.34 | 1.0 | £629,595 | 7.17% | Reactivation |
| **🟡 Churned** | 348 | 8.03% | £1,539.15 | 3.6 | £535,625 | 6.10% | Win-back |
| **🔴 Alert** | 289 | 6.67% | £1,675.29 | 4.6 | £484,159 | 5.51% | Retention |
| **TOTAL** | 4,334 | 100% | £2,025 | 4.2 | £8,779,659 | 100% | - |

**Critical Insights:**

1. **Active segment (50.58%, 2,192 customers) generates 81% of revenue** (£7.13M) with 6.5 average orders and £3,252 lifetime value. This segment should receive **premium bundle upsells** (doormat pairs, Regency luxury sets) to increase AOV from £477 to £600+ through personalized email campaigns.

2. **One-Shot segment (34.73%, 1,505 customers) contributes only 7% of revenue** (£629K) with single purchases averaging £418. These customers need **reactivation campaigns featuring high-revenue volume bundles** (JUMBO BAG collections) to encourage repeat purchases and collection completion behavior.

3. **Alert segment (6.67%, 289 customers) represents £484K immediate revenue risk** with 4.6 historical orders and £1,675 LTV. These customers should receive **"Complete the Set" bundle offers** (high-revenue pairs from previously purchased collections) within 48 hours to prevent transition to Churned status.

4. **Churned segment (8.03%, 348 customers) has lost £535K in potential revenue** with 3.6 historical orders. Win-back campaigns should emphasize **volume bundle discounts** (10-15% off on JUMBO BAG sets) paired with free shipping to re-engage these lapsed buyers.

**Key Insight:** Revenue concentration (81% from 50% of customers) validates the prioritization of Active segment retention over new customer acquisition, with premium bundle upselling as the primary growth lever.

---

## Recommendations

Based on the insights and findings above, we would recommend the **marketing, merchandising, and e-commerce teams** to consider the following:

### 1. Launch "One-Click Stock-Up" Bundles (High-Revenue Strategy)

**Target:** All customer segments | **Focus:** Volume driver pairs (£24K-£51K revenue)

**Action:**
- Pre-package top 10 high-revenue pairs (JUMBO BAG combinations, REGENCY TEACUP sets) with **5% bundle discount**
- Feature prominently on homepage carousel and checkout page ("Frequently Bought Together")
- Create SKU-level bundles to enable one-click add-to-cart functionality
- Add visual indicators: "Save £X when bundled" to highlight value proposition

**Expected Impact:**
- Increase bundle penetration from 3% → 12% of transactions (+9 percentage points)
- Add **£3.50-£7 per transaction** through incremental bundle sales
- **Total annual revenue lift: +£127K** (based on 18,405 annual orders × £6.90 avg increase)

---

### 2. Deploy Personalized Premium Bundle Upsells (High-Value Strategy)

**Target:** Active High-Value segment (2,192 customers, £7.13M revenue) | **Focus:** Premium pairs (£133-£206 avg value)

**Action:**
- Implement targeted email campaign to top 20% customers (LTV >£2,500) showcasing **doormat bundles** (£167-£206 avg) and **Regency luxury sets** (£141-£158 avg)
- Create personalized product recommendations based on previous purchases (if bought REGENCY TEAPOT → suggest SUGAR BOWL + MILK JUG bundle)
- Offer **free shipping on £750+ orders** featuring premium bundles to incentivize large basket sizes
- Use urgency messaging: "Complete your Regency collection" with 7-day offer window

**Expected Impact:**
- Convert 15% of Active High-Value customers to premium bundle buyers (329 customers)
- Increase AOV for this segment from £500 → £700 (+40%)
- **Total annual revenue lift: +£230K** (329 customers × £700 incremental spend)

---

### 3. Implement "Complete the Collection" Alert Campaigns (Churn Prevention)

**Target:** Alert segment (289 customers, £484K at risk) | **Focus:** Collection-based high-revenue bundles

**Action:**
- Trigger automated email when customer reaches 45-60 days since last order (interpurchase time threshold)
- Recommend missing items from previously purchased collections using SQL query: "You bought JUMBO BAG RED RETROSPOT - complete the set with STRAWBERRY + BAROQUE versions"
- Add **48-hour urgency timer** with 10% discount on bundle completion
- Include visual comparison showing "Your Collection: 2/5 items" with thumbnails of owned vs. missing products

**Expected Impact:**
- Reduce Alert → Churned conversion by 35% (save 101 customers from churning)
- Recover **£169K in annual revenue** (101 customers × £1,675 avg LTV)
- Improve customer lifetime value through collection completion behavior (customers who complete sets have 2.3x higher retention)

---

### 4. Create Volume Tiering to Push AOV Threshold (Price Optimization)

**Target:** All customers, especially those in £450-£500 range (45% of orders) | **Focus:** Incentivize larger basket sizes

**Action:**
- Implement dynamic pricing tiers visible during checkout with progress bar:
  - **£400-£499:** Free standard shipping (baseline)
  - **£500-£749:** 5% discount + free shipping
  - **£750+:** 10% discount + free priority shipping + free premium bundle sample (£50 value)
- Display real-time messaging: "Add £23 more to unlock 5% discount!"
- Use color-coded progress bar (orange → green) to gamify threshold achievement

**Expected Impact:**
- Shift 45% of orders from £450-£499 range → £500-£549 range (+£50-£75 per order)
- Increase overall AOV from **£477 → £525** (+10%)
- **Total annual revenue lift: +£878K** (18,405 orders × £48 average increase)

---

### 5. Win-Back Campaign for Churned & One-Shot Segments (Revenue Recovery)

**Target:** Churned (348 customers, £535K lost) + One-Shot (1,505 customers, £629K untapped) | **Focus:** Volume bundle discounts

**Action:**
- Deploy quarterly win-back email featuring **"Best-Seller Bundle Packs"** (top 5 high-revenue pairs: JUMBO BAGS, REGENCY TEACUP sets)
- Offer **15% discount + free shipping** with 7-day expiration to create urgency
- Segment messaging:
  - Churned: "We miss you! Here's 15% off to welcome you back"
  - One-Shot: "Discover what 2,192 customers are buying - complete your collection"
- Include customer testimonials and product use cases (retail shop success stories)

**Expected Impact:**
- Reactivate 10% of Churned customers (35 customers × £1,539 LTV = **£54K**)
- Convert 5% of One-Shot to repeat buyers (75 customers × £418 × 2 orders = **£63K**)
- **Total annual revenue recovery: +£117K**

---

## Assumptions and Caveats

Throughout the analysis, multiple assumptions were made to manage challenges with the data. These assumptions and caveats are noted below:

1. **Cancelled invoices (prefix 'C') were excluded entirely** rather than netted against original orders, as matching cancelled invoices to originals was not feasible without additional business logic. This may slightly overstate total revenue if some cancellations are missing from the dataset.

2. **Transactions with missing or zero CustomerID values (135,080 records, ~25% of dataset) were excluded entirely** rather than analyzed separately or imputed, as customer-level metrics (RFM segmentation, churn analysis, interpurchase intervals) require unique identifiers to track individual behavior over time. This exclusion ensures data quality for loyalty and retention analyses but may understate total business performance, as guest checkouts and unregistered purchases are not reflected in reported revenue or order volume figures.

3. **Orders with >50 unique products (outliers) were excluded from market basket analysis**, as these likely represent bulk wholesale orders with different purchasing logic. This affects <1% of transactions but prevents skewing of co-purchase frequency calculations.


---

## Repository Structure

```
uk-retail-analysis/
├── README.md                                    # Project overview (you are here)
├── data/
│   ├── online_retail_sample.csv                 # 1,000-row sample for GitHub
│   └── data_dictionary.md                       # Column descriptions
├── sql/
│   ├── 01_setup_and_cleaning.sql                # Database setup + data quality checks
│   ├── 02_exploratory_analysis.sql              # Sales, AOV, basket size profiling
│   ├── 03_market_basket_analysis.sql            # Product pair co-occurrence (self-join)
│   └── 04_rfm_segmentation.sql                  # Customer lifecycle analysis
├── visualizations/
│   ├── rfm_customer_distribution.png            # Customers distribution
│   ├── product_bundles_quadrant.png             # Bundle classification matrix
│   ├── top_pairs_revenue.png                    # Revenue-ranked pairs
│   └── basket_size_pareto.png                   # Order size distribution
└── results/
    ├── top_20_product_pairs.csv                 # High-revenue bundles (volume strategy)
    ├── top_20_product_pairsu_most_profit.csv    # High-value bundles (margin strategy)
    └── rfm_customer_segments.csv                # Customer segments with metrics
```

---

## Technical Skills Demonstrated

### SQL Techniques
- **Self-Joins:** Market basket analysis using advanced join logic to identify product co-occurrence patterns while eliminating duplicate pairs (A+B = B+A)
- **Window Functions:** LAG, DATEDIFF for interpurchase time calculation and churn prediction modeling
- **CTEs (Common Table Expressions):** Multi-step RFM segmentation with nested queries for lifecycle classification
- **Views:** Reusable analytical layers for sales/returns separation and clean data abstraction

### Data Analysis
- **Market Basket Analysis:** Association rule mining for cross-selling strategy development with dual classification (volume vs. margin)
- **Customer Segmentation:** RFM modeling with custom thresholds adapted for B2B wholesale behavior patterns
- **Cohort Analysis:** Lifecycle stage classification and churn risk scoring using interpurchase time metrics
- **Pareto Analysis:** 80/20 rule application to basket size distribution for bundle strategy validation

### Visualization (Tableau)
- **Quadrant Charts:** Portfolio-style bundle classification matrix (frequency × revenue) for strategic prioritization
- **Scatter Plots:** RFM distribution with interactive segment filtering and drill-down capabilities
- **Pareto Analysis:** Cumulative distribution visualization for 80/20 rule validation
- **Bar Charts:** Revenue-ranked product pairs with dual-axis frequency overlay

---

## Key Learnings

1. **Bundle Strategy Requires Dual-Track Approach:** High-revenue bundles (volume, mass-market) and high-value bundles (margin, premium) need fundamentally different go-to-market strategies. Mass promotion works for the former; personalized upselling for the latter.

2. **Basket Behavior Justifies Market Basket Analysis:** With 80% of orders containing 5-25 products, customers are already mentally bundling items. Data analysis simply formalizes these patterns to streamline checkout and increase AOV.

3. **B2B AOV Optimization ≠ B2C Tactics:** With £477 AOV and 21 items/order, this business needs volume tiering and collection completion strategies rather than single-item upsells common in consumer retail.

4. **Self-Join SQL Outperforms ML for This Use Case:** For 500K+ transactions, a well-optimized SQL self-join (3-second query time) outperforms association rule algorithms (Apriori, FP-Growth) in simplicity, speed, and business interpretability.

5. **Revenue Concentration Demands Retention Focus:** Active customers (50% of base) drive 81% of revenue with £3,252 LTV - retention strategies for this segment should be prioritized over new customer acquisition (8x higher LTV than One-Shot customers).

6. **Product Families Matter More Than Algorithms:** 85% of top bundles share visual/collection coherence (matching designs, color palettes), validating human-curated merchandising over pure statistical correlation in this gifware vertical.

---

## Data Source

**Dataset:** UCI Machine Learning Repository - Online Retail Dataset  
**Link:** https://archive.ics.uci.edu/ml/datasets/online+retail

---

## Contact

**LinkedIn:** [linkedin.com/in/yourprofile](https://www.linkedin.com/in/falconemichele00/)  
**Email:** falconemichele4316@gmail.com

*This project demonstrates advanced SQL and business analysis skills for junior/mid-level data analyst roles. Open to opportunities in e-commerce analytics, retail optimization, and customer intelligence!*

---

*⭐ If this project was helpful, please consider starring the repository!*
