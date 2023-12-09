library(DBI)
library(RSQLite)
library(readr)

# Delete existing db file or create necessary directory.
init_db <- function(db_path) {
  # Create directory if it doesn't exist
  dir.create(dirname(db_path), recursive = TRUE, showWarnings = FALSE)
  
  # Delete existing database file if present
  if (file.exists(db_path)) {
    file.remove(db_path)
  }
}

# Loads the dataset onto the SQLITE database
load_data <- function(db_path, tables_data) {
  # Establish connection to the SQLite database
  db_conn <- dbConnect(RSQLite::SQLite(), dbname = db_path)
  
  # Iterate over the tables_data and load each table with csv data
  # This needs to take into account 2000-2005 files for ontime data
  # Iterate over the tables_data and load each table with csv data
  for (table_name in names(tables_data)) {
    csv_files <- tables_data[[table_name]]
    
    # Check if csv_files is a list (case 'ontime' table)
    if (is.list(csv_files)) {
      for (csv_file in csv_files) {
        load_table(csv_file, table_name, db_conn)
      }
    } else {
      load_table(csv_files, table_name, db_conn)
    }
    cat("Data loaded into", table_name, "table\n")
  }
  
  # Close the database connection
  dbDisconnect(db_conn)
}

# Function to load data from a CSV file to a SQLite table
load_table <- function(csv_file, table_name, db_connection) {
  cat("Processing", csv_file, "\n")
  # show_col_types = FALSE suppress column specification messages
  data <- read_csv(csv_file, show_col_types = FALSE)
  
  # Load data into SQLite
  dbWriteTable(db_connection, table_name, data, append = TRUE)
}