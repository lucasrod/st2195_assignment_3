library(DBI)
library(RSQLite)
library(readr)

# Main function of the script; builds the schema of the SQLite database
construct_db <- function(){
  # Define database path
  if (!dir.exists("database")) {
    dir.create("database")
  }
  database_path <- "database/airline2.db"
  
  # Define table names and corresponding CSV file paths
  tables_data <- list(
    ontime = "data/2000.csv.bz2",
    airports = "data/airports.csv",
    carriers = "data/carriers.csv",
    planes = "data/plane-data.csv"
  )
  
  # Create the database and tables
  create_database_and_tables(database_path, tables_data)
}

# Function to infer column types from CSV and generate CREATE TABLE statement
generate_create_table_sql <- function(file_path, table_name) {
  data <- read_csv(file_path, n_max = 50, show_col_types = FALSE)  # Read only first 10 rows for schema inference
  col_types <- sapply(data, class)         # Infer data types
  
  # Print each column name and its type
  cat("Column types for: ", file_path, "\n")
  print(col_types)
  
  # Convert R data types to SQL data types using an anonymous function
  sql_col_types <- sapply(col_types, function(t) {
    if (t %in% c("integer", "numeric", "double")) {
      return("INTEGER")
    } else {
      return("TEXT")
    }
  })
  
  # Create the SQL statement
  columns_sql <- paste(names(data), sql_col_types, collapse = ", ")
  create_table_sql <- sprintf("CREATE TABLE IF NOT EXISTS %s (%s);", table_name, columns_sql)
  
  return(create_table_sql)
}

# Function to create database and tables
create_database_and_tables <- function(db_path, tables_data) {
  db <- dbConnect(SQLite(), dbname = db_path)
  
  for (table_name in names(tables_data)) {
    file_path <- tables_data[[table_name]]
    create_table_sql <- generate_create_table_sql(file_path, table_name)
    # Print the SQL query
    cat("Executing SQL Query:\n", create_table_sql, "\n\n")
    dbExecute(db, create_table_sql)
  }
  
  dbDisconnect(db)
}
