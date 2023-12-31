# ST2195 Assignment 3

## Overview
This repository contains the implementation of Practice Assignment 3 for the ST2195 Programming for Data Science course. The assignment involves constructing an SQLite database and replicating specific queries in both R and Python.

## Data Source
The data used for this assignment was obtained from the Harvard Dataverse, specifically from the "Data Expo 2009: Airline on time data" dataset. The dataset includes detailed flight arrival and departure information for commercial flights within the USA from October 1987 to April 2008.

- **Data Expo 2009 Dataset:** [Harvard Dataverse - Data Expo 2009: Airline on time data](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/HG7NV7)

## Database Construction
The SQLite database `airline2.db` has the following tables:
1. `ontime` from 2000 to 2005
2. `airports` from `airports.csv`
3. `carriers` from `carriers.csv`
4. `planes` from `plane-data.csv`

## Repository Structure
- `README.md` This markdown file providing a brief overview of the assignment
- `r_sql/` Folder containing the R code for constructing the database and replicating queries. It includes:
   - `main.R` Orchestrates the data processing workflow
   - `data/` Directory for storing raw dataset files, it has the following seed file [Harvard Dataverse - Data Expo 2009: Metadata](https://dataverse.harvard.edu/api/datasets/export?exporter=schema.org&persistentId=doi%3A10.7910/DVN/HG7NV7)
   - `database/` Directory for the SQLite airline2.db file
   - `scripts/` Contains R scripts for the project:
     - `download_data.R` Downloads the dataset
     - `construct_db.R` Loads the database
     - `data_analysis.R` Conducts data analysis and creates visualizations using ggplot2. This script sources queries from either `queries_in_DBI.R` or `queries_in_dplyr.R`
     - `queries_in_DBI.R` Contains database queries using the DBI package. This script is designed for direct SQL query execution and database interaction
     - `queries_in_dplyr.R`: Contains database queries using the dplyr package. This script leverages dplyr's capabilities for database interaction and query building, offering a more R-centric approach
   - `output/` Directory to save generated output files
   - `r_sql.Rproj` RStudio project file
- `python_sql/`
   - `main.py`: Orchestrates the data processing workflow.
   - `data/`: Directory for storing raw dataset files.
   - `database/`: Directory for the SQLite `airline2.db` file.
   - `scripts/`: Contains Python scripts for the project:
     - `download_data.py`: Downloads the dataset.
     - `construct_db.py`: Constructs and loads the database.
     - `data_analysis.py`: Conducts data analysis and creates visualizations.
   - `output/`: Directory to save generated output files.
