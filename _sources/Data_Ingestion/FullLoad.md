---
jupytext:
  formats: md:myst
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.11.5
kernelspec:
  display_name: Python 3
  language: python
  name: python3
---

# Pattern: Full Loader 
The Full loader implementation is one of the most straightforward patterns presented in this book. However, despite its simple two-steps construction, it has some pitfalls.

## Problem
Imagine there a dataset only changes a few times a week. It's also a very slowly evolving entity with the total number of rows not excedding 1 million. Unfortunately, `the data provide doesn't define any attribute that could help detect changed rows since the last ingestion.`

## Solution
`Because of the lack of last updated value in the dataset`, Full Loader pattern is an ideal solution to the problem. 

The simplest implmentation relies on 2 steps, the extract and load (EL). It uses native data stores commands to export data from one database, and import it to another.

```{note}
This EL approach is ideal for homogenous data stores because it doesn't require any data transformation. Extract Load jobs are also known as passthrough jobs because the data is simply passing through the pipeline, from the source to the destination.
```

However, this might not be ideal for the case that you need to load data between heterogeneous databases. For example, from a SQL Server to a PostgreSQL database. You then need to create a thing layer between the extract and load steps, the transformation step (ETL). 

## Consequences 

###  Data Volume 
- The FL implementation will often be batch jobs running **at some regular schedule**. So, if the data volume grow slowly, your infrastructure will be just fine with any issue for long time thansk to this almost constant compute needs.
- However, for more **dynamically evolving** dataset; it can lead to some issues if you use static compute resources to process it. For example, if the dataset doubles in size from one day to another, the ingestion process will be slower and can even fail due to static hardware limitations.
- `You should leverage severless services or auto-scaling capabilities to avoid this issue.`

### Data Consistency
![Database view](artifacts/database_view.png)
- When data must be completely overwritten during ingestion, several issues may arise:
  - Concurrent operations: If data consumers query while ingestion is running, they might receive partial or missing data until the operation completes
    - Mitigation options:
      - Use transactions: The best solution when available, as they manage data visibility automatically
      - Use views as abstraction layers: For data stores without transaction support, create a view that consumers query while updating underlying tables
        - Implementation example: Maintain two technical tables and switch between them during updates to ensure data remains available to consumers throughout the process
  - Second, keep in mind that you might need to use the previous version of the dataset in case of any unexpected issue. 
    - If you fully overwrite your dataset, you might not be able to perform this action, unless you use a format supporting the time travel feature, such as `Delta Lake, Apache Iceberg, or yet GCP BigQuery`. 
    - Eventually, you can also implement the feature on your own by relying on the same single data exposition abstraction concept presented in Figure 2-1.

## Examples 
- If you ingest a dataset between two identical or compatible data stores, you can simply write a script and deploy to your runtime service. 
```{code-cell} ipython3
aws s3 sync s3://input-bucket s3://output-bucket --delete
```
