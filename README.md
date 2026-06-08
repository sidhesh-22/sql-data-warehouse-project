# End-to-End Data Warehouse in PostgreSQL

## 📌 Executive Summary

Built a modern data warehouse in PostgreSQL to consolidate CRM and ERP data into a centralized analytics platform. The solution ingests raw CSV data, applies data quality and business transformations, and delivers analytics-ready datasets through a dimensional star schema.

The project implements a Medallion Architecture (Bronze, Silver, Gold) with automated ETL pipelines using PostgreSQL stored procedures. Data from six source systems was integrated, standardized, and modeled into fact and dimension tables optimized for reporting and business intelligence.

---

## 🧩 Business Problem

Organizations often store customer, product, and sales information across multiple operational systems. In this scenario:

CRM systems contain customer, product, and sales transaction data
ERP systems contain customer demographics, location information, and product categorization
Data exists in siloed CSV exports with inconsistent formats and duplicate records

Business stakeholders lacked a centralized and trusted dataset to answer questions such as:

Who are our highest-value customers?
Which products generate the most revenue?
How do sales perform across customer segments and geographies?
What product categories drive business growth?

To solve this challenge, a modern data warehouse was developed to integrate, clean, and model data into an analytics-ready environment.

---

## 🔬 Methodology


<p align="center">
  <img src="docs/Data WH Architecture.jpg" width="900">
  <br>
  <em>Figure 1: Medallion architecture implemented using PostgreSQL with Bronze, Silver, and Gold layers.</em>
</p>


i) Bronze Layer (Raw Data)

#### Purpose:

- Ingest source CSV files without transformation
- Preserve source system fidelity
- Support data traceability

#### Key Activities:

- Full-load ingestion
- Truncate and reload strategy
- Raw data storage

## Data Integration

<p align="center">
  <img src="docs/Data Integration.jpg" width="900">
  <br>
  <em>Figure 2: CRM and ERP systems integrated into the warehouse through the Bronze layer.</em>
</p>

ii) Silver Layer (Cleaned & Standardized Data)

#### Purpose:

- Improve data quality
- Apply business rules
- Standardize source systems

#### Key Activities:

- Deduplication using ROW_NUMBER()
- Data cleansing using TRIM()
- Standardization using CASE
- Null handling using COALESCE()
- Date normalization
- Product and customer enrichment

iii) Gold Layer (Business-Ready Data)

#### Purpose:

- Deliver analytical datasets

#### Key Activities:

- Fact and Dimension modeling
- Star Schema design
- Business metric generation
- Reporting optimization

## Data Model

<p align="center">
  <img src="docs/Data Model.jpg" width="900">
  <br>
  <em>Figure 3: Sales data mart designed using a star schema with fact and dimension tables.</em>
</p>

---

## Skills Demonstrated
Data Engineering, 
ETL Pipeline Design,
Data Warehouse Development, 
Medallion Architecture, 
Data Integration, 
Data Modeling, 
Batch Processing, 

## SQL Development
Complex Joins, 
Common Table Expressions (CTEs), 
Window Functions, 
Aggregations, 
Conditional Logic
Data Transformation

## Database Engineering
Schema Design, 
Fact Table Design, 
Dimension Table Design, 
Surrogate Key Generation, 
Referential Modeling, 
View Creation

---

## 📊 Results & Business Recommendations

### Key Insights Enabled

The warehouse enables analysis of:

- Customer purchasing behavior
- Product performance
- Revenue trends
- Geographic sales distribution
- Customer demographics
- Product category profitability

### Primary Stakeholders

- Sales Leadership
- Marketing Teams
- Business Analysts
- Executive Management
- Data & Analytics Teams

--- 

## Recommendations
### Customer Analytics

- Use customer segmentation to identify high-value customers and improve retention strategies.

### Product Strategy

- Prioritize high-performing product categories and evaluate underperforming products for optimization.

### Geographic Expansion

- Leverage customer location data to identify high-growth regions and expansion opportunities.

### Reporting Standardization

- Use Gold Layer datasets as the organization's trusted reporting source to eliminate conflicting metrics.

--- 

## 🚀 Next Steps

Future enhancements that would increase business value include:

### Incremental Loading

- Replace full refresh loads with incremental ETL processing to improve scalability.

### Data Quality Framework

- Implement automated validation, anomaly detection, and quality score monitoring.

### Historical Tracking

- Introduce Slowly Changing Dimensions (SCD Type 2) to track customer and product changes over time.

### Orchestration

- Integrate with Airflow or other scheduling platforms for production-grade workflow management.

### Cloud Modernization

- Migrate the warehouse to Snowflake, Azure Synapse, BigQuery, or Redshift for enterprise-scale analytics.

### Business Intelligence

- Connect Power BI or Tableau dashboards directly to the Gold Layer for self-service analytics.
