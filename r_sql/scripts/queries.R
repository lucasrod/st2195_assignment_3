library(DBI)
library(dplyr)
library(ggplot2)
library(RSQLite)

execute_queries <- function(db_path){
  conn <- connect_to_db(db_path)
  
  cancelled_flights <- get_cancelled_flights_by_carrier(conn)
  print("Company with highest number of cancelled flights")
  print(cancelled_flights)
  #plot_cancelled_flights(cancelled_flights)
  
  cancelled_flights_rate <- get_cancelled_flights_rate(conn)
  print("Company with highest rate of cancelled flights")
  print(cancelled_flights_rate)
  
  avg_delay <- get_avg_dep_delay_by_planes(conn)
  print("Airplane with lowest average departure delay (in minutes)")
  print(avg_delay)
  
  inbound_flights <- get_inbound_flights_by_cities(conn)
  print("City with highest number of inbound flights")
  print(inbound_flights)
  
  # Repeat for other queries and visualizations
  
  dbDisconnect(conn)
}

connect_to_db <- function(db_path) {
  dbConnect(SQLite(), db_path)
}

# General function to run a query
execute_query <- function(conn, query) {
  dbGetQuery(conn, query)
}

# Function for each specific query
get_cancelled_flights_by_carrier <- function(conn) {
  query <- "
  SELECT UniqueCarrier, COUNT(*) AS cancelled_flights
  FROM ontime
  WHERE Cancelled = 1
  GROUP BY UniqueCarrier
  ORDER BY cancelled_flights DESC
  "
  execute_query(conn, query)
}

get_cancelled_flights_rate <- function(conn) {
  query <- "
  SELECT UniqueCarrier, SUM(Cancelled) / COUNT(*) AS cancel_rate
  FROM ontime
  GROUP BY UniqueCarrier
  ORDER BY cancel_rate DESC
  "
  execute_query(conn, query)
}

get_avg_dep_delay_by_planes<- function(conn) {
  query <- "
  SELECT tailnum, AVG(DepDelay) AS avg_delay
  FROM ontime
  WHERE Cancelled = 0 AND Diverted = 0
  GROUP BY tailnum
  ORDER BY avg_delay ASC
  "
  execute_query(conn, query)
}

get_inbound_flights_by_cities <- function(conn) {
  query <- "
  SELECT Dest, COUNT(*) AS inbound_flights
  FROM ontime
  WHERE Cancelled = 0
  GROUP BY Dest
  ORDER BY inbound_flights DESC
  "
  execute_query(conn, query)
}

plot_cancelled_flights <- function(data) {
  # First sort the data, then slice the first 5 rows
  top_data <- data %>%
    arrange(cancelled_flights) %>%
    slice(1:5)
    
  plot <- ggplot(data, aes(x = reorder(UniqueCarrier, cancelled_flights), y = cancelled_flights)) +
    geom_bar(stat = "identity") +
    theme_minimal() +
    labs(title = "Cancelled Flights by Airline", x = "Airline", y = "Number of Cancelled Flights")
  print(plot)
}


