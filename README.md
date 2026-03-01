# Data Warehouse Project Portfolio

### Building a Professional SQL Server Data Warehouse with Structured ETL, Dimensional Modeling, Data Quality Enforcement, and Analytical Reporting

---

## Overview

This repository showcases the design and implementation of a production-style Data Warehouse built using **SQL Server (SSMS)**.

The project demonstrates a complete end-to-end workflow:

1. Raw data ingestion (CSV-based ERP and CRM sources)
2. Data cleansing and transformation (Silver layer)
3. Dimensional modeling using a Star Schema (Gold layer)
4. Quality validation and enforcement
5. Analytics-ready datasets for reporting and business intelligence

The architecture follows a modern **Bronze → Silver → Gold layered approach**, ensuring maintainability, scalability, and analytical performance.

---

## Architecture

The warehouse is structured into three logical layers:

### 🥉 Bronze Layer – Raw Ingestion
- Direct import of source CSV files
- Minimal transformation
- Source-aligned naming
- Designed for traceability and auditability

### 🥈 Silver Layer – Cleansed & Standardized
- Data cleaning and normalization
- Deduplication and integrity checks
- Domain standardization
- Business rule validation
- Preparation for dimensional modeling

### 🥇 Gold Layer – Analytical Model
- Star Schema design
- Dimension tables (`dim_*`)
- Fact tables (`fact_*`)
- Surrogate keys for stable joins
- Optimized for BI and reporting workloads

---

## Core Features

### ETL Workflows
- Structured data ingestion from multiple systems
- Layered transformation logic
- Deterministic joins and integration logic

### Data Quality Enforcement
- Duplicate detection
- Null validation
- Domain checks
- Date integrity validation
- Business rule verification
- Sales consistency validation (quantity × price = revenue)

### Dimensional Modeling
- Star Schema implementation
- Clearly defined grain for fact tables
- Surrogate key strategy
- Conformed dimensions
- Business-aligned naming conventions

### Analytical Enablement
- Customer segmentation analysis
- Product performance tracking
- Revenue and sales trend analysis
- Optimized datasets for BI tools

---

## Project Specifications

- **Source Systems:** ERP and CRM (CSV format)
- **Integration Strategy:** Unified analytical data model
- **Historization:** Current-state modeling (no SCD implementation in this version)
- **Data Quality:** Enforced at Silver layer
- **Documentation:** Naming conventions, schema standards, and data catalog included

---

## Repository Structure
**Bronze**
- raw ingestion scripts

**Silver**
- transformation scripts
- cleansing logic
- quality checks

**Gold**
- dimensional model DDL
- fact & dimension views

**Docs**
- data catalog
- naming conventions
- architecture documentation

---

## Design Principles

- Layer isolation (no cross-layer contamination)
- Clear separation of transformation and presentation logic
- Stable surrogate key strategy
- Business-first modeling approach
- Performance-oriented schema design
- Readability and maintainability

---

## BI & Analytics Objectives

The analytical model enables SQL-based insights across:

### Customer Behavior
- Purchase frequency
- Revenue contribution
- Segmentation analysis

### Product Performance
- Category revenue trends
- Margin tracking
- Lifecycle visibility

### Sales Trends
- Period-over-period revenue
- Order volume growth
- Fulfillment performance

These outputs support informed, data-driven decision-making.

---

## Technologies Used

- SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL
- Star Schema modeling
- Structured ETL workflows

---

## Future Enhancements

Planned architectural improvements include:

- Slowly Changing Dimensions (SCD Type 2)
- Incremental load processing
- Persistent surrogate key generation
- Automated quality check procedures
- Data lineage tracking
- CI/CD integration for database deployment

---

## License

This project is **All Rights Reserved**.

This repository is intended for portfolio demonstration purposes only.  
Viewing is permitted; copying, modifying, or redistributing the code is not allowed.

---

## About Me

Hi, I'm **Crystal** (aka Vitaray888), an AI Systems Engineer focused on solving real-world problems through intelligent systems and advanced data solutions.

My work spans:

- Data Engineering
- Data Architecture
- Advanced Analytics
- AI-Driven Modeling
- Intelligent Automation Systems

I focus on building scalable, production-grade systems that bridge structured data engineering with intelligent decision-making frameworks.

---

## Contact

If you're interested in discussing data architecture, AI systems, or collaboration opportunities, feel free to connect
- 📧 Connect with me: [crystal@example.com](mailto:crystal@example.com)
