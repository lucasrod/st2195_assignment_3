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
# ST2195 Assignment 3

## Overview
This repository contains the implementation of Practice Assignment 3 for the ST2195 Programming for Data Science course. The assignment involves constructing an SQLite database named `airline2.db` and replicating specific queries in both R and Python.

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
- `r_sql/`: Folder containing the R code for constructing the database and replicating queries. It includes:
   - `data/`: Directory for storing raw data files downloaded from the Dataverse.
   - `scripts/`: Contains R scripts for the project:
     - `download_data.R`: For downloading the data.
     - `construct_db.R`: For constructing the database and schema.
     - `load_data.R`: For loading the database with the downloaded data.
     - `make_queries.R`: For performing the queries.
     - `save_to_csv.R`: For saving query results to CSV files.
   - `output/`: Directory for storing outputs like CSV files generated by scripts.
   - `r_sql.Rproj`: RStudio project file.
- `python_sql/`: Folder containing the Python code for database construction and query replication.

## License
The dataset is available under the Creative Commons CC0 1.0 Universal Public Domain Dedication.
