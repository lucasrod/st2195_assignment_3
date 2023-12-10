library(DBI)
library(dplyr)
library(ggplot2)
library(RSQLite)

execute_queries <- function(db_path){
  conn <- connect_to_db(db_path)
  
  cancelled_flights <- get_cancelled_flights_by_carrier(conn)
  cat("Company with highest number of cancelled flights\n")
  print(cancelled_flights)
  plot_cancelled_flights(cancelled_flights, "cancelled_flights.png")
  save_to_csv(cancelled_flights, "cancelled_flights.csv")
  
  cancelled_flights_rate <- get_cancelled_flights_rate(conn)
  cat("Company with highest rate of cancelled flights\n")
  print(cancelled_flights_rate)
  plot_cancelled_flights_rate(cancelled_flights_rate, "cancelled_flights_rate.png")
  save_to_csv(cancelled_flights_rate, "cancelled_flights_rate.csv")
  
  avg_delay <- get_avg_dep_delay_by_planes(conn)
  cat("Airplane with lowest average departure delay (in minutes)\n")
  print(avg_delay)
  plot_avg_delay(avg_delay, "avg_delay.png")
  save_to_csv(avg_delay, "avg_delay.csv")
  
  inbound_flights <- get_inbound_flights_by_cities(conn)
  cat("City with highest number of inbound flights\n")
  print(inbound_flights)
  plot_inbound_flights(inbound_flights, "inbound_flights.png")
  save_to_csv(inbound_flights, "inbound_flights.csv")
  
  dbDisconnect(conn)
}

connect_to_db <- function(db_path) {
  dbConnect(SQLite(), db_path)
}

# General function to run a query
execute_query <- function(conn, query) {
  cat(query, "\n")
  dbGetQuery(conn, query)
}

# Function for each specific query
get_cancelled_flights_by_carrier <- function(conn) {
  query <- "
  SELECT Description AS Carrier, UniqueCarrier, COUNT(*) AS cancelled_flights
  FROM ontime o
  JOIN carriers c ON o.UniqueCarrier = c.Code
  WHERE Cancelled = 1 AND UniqueCarrier IN ('UA', 'AA', '9E', 'DL')
  GROUP BY UniqueCarrier, Description
  ORDER BY cancelled_flights DESC
  "
  execute_query(conn, query)
}

get_cancelled_flights_rate <- function(conn) {
  query <- "
  SELECT Description AS Carrier, UniqueCarrier, SUM(Cancelled) / COUNT(*) AS cancel_rate
  FROM ontime o
  JOIN carriers c ON o.UniqueCarrier = c.Code
  WHERE Cancelled = 1 AND UniqueCarrier IN ('UA', 'AA', '9E', 'DL')
  GROUP BY UniqueCarrier, Description
  ORDER BY cancel_rate DESC
  "
  execute_query(conn, query)
}

get_avg_dep_delay_by_planes<- function(conn) {
  query <- "
  SELECT model, AVG(DepDelay) AS avg_delay
  FROM ontime o
  JOIN planes p ON o.tailnum = p.tailnum
  WHERE Cancelled = 0 AND Diverted = 0 AND DepDelay > 0
  GROUP BY model
  ORDER BY avg_delay ASC
  "
  execute_query(conn, query)
}

get_inbound_flights_by_cities <- function(conn) {
  query <- "
  SELECT city, Dest, COUNT(*) AS inbound_flights
  FROM ontime o
  JOIN airports a ON o.Dest = a.iata
  WHERE Cancelled = 0
  GROUP BY Dest, city
  ORDER BY inbound_flights DESC
  "
  execute_query(conn, query)
}

plot_cancelled_flights <- function(data, filename) {
  plot <- ggplot(data, aes(x = reorder(UniqueCarrier, cancelled_flights), y = cancelled_flights)) +
    geom_bar(stat = "identity") +
    theme_minimal() +
    labs(title = "Cancelled Flights by Airline", x = "Airline", y = "Number of Cancelled Flights")
  print(plot)
  filename <- paste0("output/", filename)
  ggsave(filename, plot)
}

plot_cancelled_flights_rate <- function(data, filename) {
  plot <- ggplot(data, aes(x = reorder(Carrier, cancel_rate), y = cancel_rate)) +
    geom_bar(stat = "identity") +
    theme_minimal() +
    labs(title = "Cancelled Flights Rate by Airline", x = "Airline", y = "Cancellation Rate")
  print(plot)
  filename <- paste0("output/", filename)
  ggsave(filename, plot)
}

plot_avg_delay <- function(data, filename) {
  plot <- ggplot(data, aes(x = model, y = avg_delay)) +
    geom_bar(stat = "identity") +
    theme_minimal() +
    labs(title = "Average Departure Delay by Plane Model", x = "Plane Model", y = "Average Delay (minutes)")
  print(plot)
  filename <- paste0("output/", filename)
  ggsave(filename, plot)
}

plot_inbound_flights <- function(data, filename) {
  plot <- ggplot(data, aes(x = reorder(city, inbound_flights), y = inbound_flights)) +
    geom_bar(stat = "identity") +
    theme_minimal() +
    labs(title = "Inbound Flights by City", x = "City", y = "Number of Inbound Flights")
  print(plot)
  filename <- paste0("output/", filename)
  ggsave(filename, plot)
}

save_to_csv <- function(data, filename) {
  filename <- paste0("output/", filename)
  write.csv(data, filename, row.names = FALSE)
  cat(paste("Data saved to", filename, "\n"))
}
