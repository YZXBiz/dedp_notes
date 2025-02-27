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
This EL approach is ideal for homogenous data stores because it doesn't require any data transformation.
```