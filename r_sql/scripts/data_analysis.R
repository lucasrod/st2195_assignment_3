library(DBI)
library(dplyr)
library(ggplot2)
library(RSQLite)

source("scripts/queries_in_DBI.R")

execute_queries <- function(db_path){
  conn <- dbConnect(SQLite(), db_path)
  
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
  
  cancelled_flights_rate_2 <- get_cancelled_flights_rate_2(conn)
  cat("Company with highest rate of cancelled flights 2\n")
  print(cancelled_flights_rate_2)
  plot_cancelled_flights_rate(cancelled_flights_rate_2, "cancelled_flights_rate_2.png")
  save_to_csv(cancelled_flights_rate_2, "cancelled_flights_rate_2.csv")
  
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

plot_cancelled_flights <- function(data, filename) {
  plot <- ggplot(data, aes(x = reorder(carrier, cancelled_flights), y = cancelled_flights)) +
    geom_bar(stat = "identity") +
    theme_minimal() +
    labs(title = "Cancelled Flights by Airline", x = "Airline", y = "Number of Cancelled Flights")
  print(plot)
  filename <- paste0("output/", filename)
  ggsave(filename, plot)
}

plot_cancelled_flights_rate <- function(data, filename) {
  plot <- ggplot(data, aes(x = reorder(carrier, cancel_rate), y = cancel_rate)) +
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
