# ST2195 Assignment 3

## Overview
This repository contains the implementation of Practice Assignment 3 for the ST2195 Programming for Data Science course. The assignment involves constructing an SQLite database and replicating specific queries in both R and Python.

## Data Source
The data used for this assignment was obtained from the Harvard Dataverse, specifically from the "Data Expo 2009: Airline on time data" dataset. The dataset includes detailed flight arrival and departure information for commercial flights within the USA from October 1987 to April 2008.

- **Data Expo 2009 Dataset:** [Data Expo 2009: Airline on time data](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/HG7NV7)

## Database Construction
The SQLite database `airline2.db` comprises the following tables:
1. `ontime`: Data from 2000 to 2005 (inclusive).
2. `airports`: Data from `airports.csv`.
3. `carriers`: Data from `carriers.csv`.
4. `planes`: Data from `plane-data.csv`.

## Repository Structure
- `README.md`: This markdown file providing a brief overview of the assignment.
- `r_sql/`: Folder containing the R code for constructing the database and replicating queries.
- `python_sql/`: Folder containing the Python code for database construction and query replication.

## License
The used dataset is available under the Creative Commons CC0 1.0 Universal Public Domain Dedication.