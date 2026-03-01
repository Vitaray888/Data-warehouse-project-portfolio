# Naming Conventions

This document defines the official naming standards for schemas, tables, views, columns, and programmable objects within the data warehouse.

The objective is to ensure:

- Consistency
- Clarity
- Maintainability
- Scalability across layers

---

# Table of Contents

1. [General Principles](#general-principles)
2. [Schema Naming](#schema-naming)
3. [Table Naming Conventions](#table-naming-conventions)
   - [Bronze Layer](#bronze-layer)
   - [Silver Layer](#silver-layer)
   - [Gold Layer](#gold-layer)
4. [Column Naming Conventions](#column-naming-conventions)
   - [Surrogate Keys](#surrogate-keys)
   - [Foreign Keys](#foreign-keys)
   - [Technical Columns](#technical-columns)
5. [Stored Procedure Naming Conventions](#stored-procedure-naming-conventions)

---

# General Principles

- **Case Style:** All object names use `snake_case`.
- **Character Rules:** Lowercase letters and underscores (`_`) only.
- **Language:** English only.
- **Reserved Words:** SQL reserved keywords must not be used as object names.
- **Pluralization:** Dimension and fact tables use plural nouns (e.g., `dim_customers`, `fact_sales`).
- **Clarity Over Brevity:** Names must be descriptive and business-aligned.

---

# Schema Naming

Schemas represent architectural layers:

| Schema  | Purpose |
|----------|----------|
| `bronze` | Raw source-aligned ingestion layer |
| `silver` | Cleansed and standardized transformation layer |
| `gold`   | Business-aligned analytical layer |

Schema names must always reflect the architectural layer.

---

# Table Naming Conventions

## Bronze Layer

**Pattern:**  
`<source_system>_<entity>`

- `<source_system>`: Abbreviated source name (e.g., `crm`, `erp`)
- `<entity>`: Exact table name from the source system (no renaming)

Examples:
- `crm_customer_info`
- `erp_sales_order`

Rules:
- No structural renaming.
- No business abstraction.
- Tables mirror source structure as closely as possible.

---

## Silver Layer

**Pattern:**  
`<source_system>_<entity>`

Rules:
- Naming remains aligned with the source system.
- Minor structural transformations are allowed.
- No business renaming at this stage.
- Standardization (data types, formats) may occur.

Note: Silver maintains source traceability while improving data quality.

---

## Gold Layer

Gold tables must use business-aligned naming.

**Pattern:**  
`<category>_<entity>`

- `<category>` defines the analytical role.
- `<entity>` is a business-aligned name.

Examples:
- `dim_customers`
- `dim_products`
- `fact_sales`
- `agg_sales_monthly`

### Category Prefix Glossary

| Prefix  | Meaning |
|----------|----------|
| `dim_`  | Dimension table |
| `fact_` | Fact table |
| `agg_`  | Aggregated table |
| `bridge_` | Bridge table (many-to-many relationships) |

Rules:
- Gold tables must not expose source-system naming.
- Names must reflect business terminology.
- Grain must be clearly defined in documentation.

---

# Column Naming Conventions

## Surrogate Keys

All dimension tables must use surrogate keys as primary keys.

**Pattern:**  
`<entity>_key`

Examples:
- `customer_key`
- `product_key`

Rules:
- Surrogate keys must be integer-based where possible.
- Surrogate keys are system-generated.
- Must not contain business meaning.

---

## Foreign Keys

Foreign keys in fact tables must reference dimension surrogate keys.

**Pattern:**  
`<entity>_key`

Examples:
- `customer_key`
- `product_key`

Rules:
- Naming must exactly match the referenced dimension key.
- No source-system keys are used for joins in Gold.

---

## Technical Columns

System-generated metadata columns must use the `dwh_` prefix.

**Pattern:**  
`dwh_<description>`

Examples:
- `dwh_load_date`
- `dwh_insert_timestamp`
- `dwh_update_timestamp`

Rules:
- Reserved exclusively for system metadata.
- Must not contain business logic.
- Must be consistent across layers where applicable.

---

# Stored Procedure Naming Conventions

Stored procedures responsible for data loading must follow:

**Pattern:**  
`load_<layer>`

Examples:
- `load_bronze`
- `load_silver`
- `load_gold`

If procedures are entity-specific, use:

`load_<layer>_<entity>`

Examples:
- `load_gold_dim_customers`
- `load_gold_fact_sales`

Rules:
- Names must reflect execution intent.
- One procedure per logical load unit.
- Avoid generic names such as `sp_load_data`.

---
