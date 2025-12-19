# dbt Databricks Training Lab

This repository contains the source code and documentation for dbt training on Databricks. The project demonstrates best practices in analytics engineering, focusing on modular architecture and proactive data governance.

---

## 🏗️ Project Architecture

The project is organized into a multi-layered modeling structure to ensure data lineage and maintainability:

* **Staging Layer:** Initial cleaning and standardization of raw source data. Only renaming, recasting, null'ifying, and testing primary keys.
* **Intermediate Layer:** Complex business logic, standardized transformations, and joining of different tables that bridge staging and marts layer.
* **Marts Layer:** Consumer-ready **Dimensions** and **Fact** tables optimized for analytics and BI.

---

## 🛡️ Data Reliability: Contracts vs. Tests

A core component of this training is understanding how to protect downstream consumers from breaking changes. The main difference lies in **what happens to the production data when a failure occurs.**

### Data Contracts (The "Gatekeeper")
Located in `models/marts/fct_sales.yml`, the data contract acts as a **pre-flight check**.
* **Execution:** Validated *before* or *during* the model run.
* **Failure Behavior:** If a contract is violated, **the model will not even run.** The production data is **not updated**, keeping the existing (stale but stable) data intact.
* **Business Impact:** Prevents "breaking" the schema for downstream BI tools. It is safer to show stale data than to crash a dashboard.

### Data Tests (The "Quality Monitor")
Standard dbt tests (e.g., `unique`, `not_null`) are **post-run checks**.
* **Execution:** Performs a SQL query *after* the model has successfully run.
* **Failure Behavior:** The model **is already updated** in production before the test fails. 
* **Business Impact:** Because the data is already live, you must proactively inform stakeholders that the model is incorrect while you work on a fix.

### Comparison Table

| Feature | Data Contracts | Data Tests |
| :--- | :--- | :--- |
| **Timing** | Pre-flight (Build-time) | Post-run |
| **Production Table** | **Not updated** if failed | **Updated** regardless of failure |
| **Stakeholder Risk** | Low (Data is stale, but correct) | High (Data is wrong/broken) |
| **Focus** | Schema & Type safety | Value-level integrity |

---

## 📝 Implementing Model Contracts

To successfully enforce a contract in dbt on Databricks, keep these three requirements in mind:

1.  **Model Level Config:** You must explicitly enable the contract in your `.yml` file:
    ```yaml
    models:
      - name: fct_sales
        config:
          contract:
            enforced: true
    ```
2.  **Explicit Data Types:** Every column must have a specified `data_type` (e.g., `integer`, `varchar`, `boolean`, `date`).
3.  **Production Stability:** Use contracts for your Marts layer to maintain a "fixed" API for your BI tools. This ensures that upstream changes do not unexpectedly break your downstream dashboards.

---

## 🔐 Environment Isolation & Profile Best Practices

Below you'll find some of the best practices leveraging dbt and the Databricks Unity Catalog.

### Developer Schema Isolation
To avoid "collisions" where developers overwrite each other's data, every team member uses their own dedicated schemas for every layer.
* **Naming Convention:** `dbt_<user>_dev_<layer>`
* **Examples:** * `dbt_developername_dev_stg`
    * `dbt_developername_dev_int`
    * `dbt_developername_dev_marts`

### Production Protection
The **Production** environment is a protected zone.
* **Restricted Access:** No developer has `CREATE` or `MODIFY` permissions in the production catalog.
* **CI/CD Only:** Changes to production schemas (e.g., `prod_stg`, `prod_int`, and `prod_marts`) can **only** be executed by the Service Principal via a CI/CD pipeline (e.g., GitHub Actions).
* **Validation:** All code must pass data contracts and tests in a Pull Request (PR) schema before being merged to production.

---

## 🚀 Databricks Performance & Governance

### 1. Liquid Clustering
For high-volume tables in the Marts layer, use **Liquid Clustering** instead of manual partitioning or Z-Ordering. This provides the best performance for concurrent queries and data skipping.
  ```yaml
    +cluster_by: ["customer_id", "transaction_date"]
  ```
### 2. Unity Catalog & Governance
Unity Catalog provides a central place to manage data access and track lineage.

Three-Tier Namespace: Models are structured using <catalog>.<schema>.<table_name> for clear ownership.

Column-Level Lineage: By using dbt with Unity Catalog, Databricks automatically visualizes how data flows from raw staging models into final business marts.

### 3. Incremental Strategy (Merge)
For large datasets, use the merge incremental strategy. This ensures that only new or updated records are processed, significantly reducing compute costs compared to a full refresh.

```sql
{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge',
    on_schema_change='fail'
) }}
```
