# main.R
# This script orchestrates the entire workflow of the project

# Source individual scripts
source("scripts/download_data.R")
source("scripts/construct_db.R")
source("scripts/load_data.R")
source("scripts/make_queries.R")
source("scripts/save_to_csv.R")

# Execute the workflow
# 1. Download Data
cat("Downloading data...\n")
download_data()

# 2. Construct Database
cat("Constructing database...\n")
construct_db()

# 3. Load Data into Database
cat("Loading data into database...\n")
load_data()

# 4. Make Queries
cat("Executing queries...\n")
query_results <- make_queries()

# 5. Save Results to CSV
cat("Saving query results to CSV...\n")
save_to_csv(query_results, "output/query_results.csv")

cat("Workflow completed successfully.\n")
