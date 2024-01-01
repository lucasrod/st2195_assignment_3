source("scripts/download_data.R")
source("scripts/construct_db.R")
source("scripts/data_analysis.R")

# Define some initial values for the dataset and database files
required_files <- c("2000.csv.bz2", "2001.csv.bz2", "2002.csv.bz2",
                    "2003.csv.bz2", "2004.csv.bz2", "2005.csv.bz2",
                    "airports.csv", "carriers.csv", "plane-data.csv",
                    "variable-descriptions.csv")

database_path <- "database/airline2.db"

# Define table names and corresponding CSV file paths
tables_data <- list(
  ontime = list("data/2000.csv.bz2", "data/2001.csv.bz2",
                "data/2002.csv.bz2", "data/2003.csv.bz2",
                "data/2004.csv.bz2", "data/2005.csv.bz2"),
  airports = "data/airports.csv",
  carriers = "data/carriers.csv",
  planes = "data/plane-data.csv")

# Execute the workflow
message("Downloading Data Expo 2009: Airline Time Dataset\n")
download_data(required_files)

# Build SQLite db file and tables
if (!file.exists(database_path)) {
  message("Building", database_path, "\n")
  init_db(database_path)
  
  # Load the actual data
  message("Loading the data\n")
  load_data(database_path, tables_data)
}

message("Executing queries...\n")
execute_queries(database_path)

message("Assignment 3 completed\n")
