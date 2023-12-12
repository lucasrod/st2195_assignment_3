# Function for each specific query using dplyr
get_cancelled_flights_by_carrier <- function(conn) {
  # Connect to database and join tables
  ontime_tbl <- tbl(conn, "ontime")
  carriers_tbl <- tbl(conn, "carriers")
  
  joined_tbl <- ontime_tbl %>%
    inner_join(carriers_tbl, by = c(UniqueCarrier = "Code"))
  
  # Filter, group, and count cancelled flights
  filtered_tbl <- joined_tbl %>%
    filter(Cancelled == 1, UniqueCarrier %in% c("UA", "AA", "9E", "DL")) %>%
    group_by(UniqueCarrier, Description) %>%
    summarize(cancelled_flights = n(), .groups = "drop")
  
  # Order results
  cancelled_flights <- filtered_tbl %>%
    select(carrier = Description, code = UniqueCarrier, cancelled_flights) %>%
    arrange(desc(cancelled_flights))
  
  return(cancelled_flights)
}


get_cancelled_flights_rate <- function(conn) {
  # Connect to database and join tables
  ontime_tbl <- tbl(conn, "ontime")
  carriers_tbl <- tbl(conn, "carriers")
  
  joined_tbl <- ontime_tbl %>%
    inner_join(carriers_tbl, by = c(UniqueCarrier = "Code"))
  
  # Filter, group, and calculate cancellation rate
  filtered_tbl <- joined_tbl %>%
    filter(UniqueCarrier %in% c("UA", "AA", "9E", "DL")) %>%
    group_by(UniqueCarrier, Description) %>%
    summarize(cancel_rate = sum(Cancelled) / n(), .groups = "drop")
  
  # Order results
  cancelled_rate <- filtered_tbl %>%
    select(carrier = Description, code = UniqueCarrier, cancel_rate) %>%
    arrange(desc(cancel_rate))
  
  return(cancelled_rate)
}

get_cancelled_flights_rate_2 <- function(conn) {
  # Connect to database
  ontime_tbl <- tbl(conn, "ontime")
  carriers_tbl <- tbl(conn, "carriers")
  
  # Calculate cancelled flights per carrier
  cancelled_flights <- ontime_tbl %>%
    filter(Cancelled == 1) %>%
    inner_join(carriers_tbl, by = c(UniqueCarrier = "Code")) %>%
    filter(Description %in% c("United Air Lines Inc.", "American Airlines Inc.",
                              "Pinnacle Airlines Inc.", "Delta Air Lines Inc.")) %>%
    group_by(Description, UniqueCarrier) %>%
    summarize(CancelCount = n(), .groups = "drop")
  
  # Calculate total flights per carrier
  total_flights <- ontime_tbl %>%
    inner_join(carriers_tbl, by = c(UniqueCarrier = "Code")) %>%
    filter(Description %in% c("United Air Lines Inc.", "American Airlines Inc.",
                              "Pinnacle Airlines Inc.", "Delta Air Lines Inc.")) %>%
    group_by(Description) %>%
    summarize(TotalFlights = n(), .groups = "drop")
  
  # Join tables and calculate cancellation rate
  cancelled_rate <- cancelled_flights %>%
    left_join(total_flights, by = "Description") %>%
    mutate(cancel_rate = as.numeric(CancelCount) / TotalFlights) %>%
    select(carrier = Description, code = UniqueCarrier, cancel_rate) %>%
    arrange(desc(cancel_rate))
  
  return(cancelled_rate)
}

get_avg_dep_delay_by_planes <- function(conn) {
  # Connect to database and join tables
  ontime_tbl <- tbl(conn, "ontime")
  planes_tbl <- tbl(conn, "planes")
  
  joined_tbl <- ontime_tbl %>%
    inner_join(planes_tbl, by = c("TailNum" = "tailnum"))
  
  # Filter, group, and calculate average delay
  filtered_tbl <- joined_tbl %>%
    filter(Cancelled == 0, Diverted == 0, DepDelay > 0) %>%
    filter(model %in% c("737-230", "ERJ 190-100 IGW", "A330-223", "737-282")) %>%
    group_by(model) %>%
    summarize(avg_delay = mean(DepDelay), .groups = "drop")

  # Order results
  avg_delay_tbl <- filtered_tbl %>%
    arrange(avg_delay)
  
  return(avg_delay_tbl)
}

get_inbound_flights_by_cities <- function(conn) {
  # Connect to database and join tables
  ontime_tbl <- tbl(conn, "ontime")
  airports_tbl <- tbl(conn, "airports")
  
  joined_tbl <- ontime_tbl %>%
    inner_join(airports_tbl, by = c(Dest = "iata"))
  
  # Filter, group, and count inbound flights
  filtered_tbl <- joined_tbl %>%
    filter(Cancelled == 0) %>%
    filter(city %in% c('Chicago', 'Atlanta', 'New York', 'Houston')) %>%
    group_by(city) %>%
    summarize(inbound_flights = n(), .groups = "drop")
  
  # Order results
  inbound_flights <- filtered_tbl %>%
    arrange(desc(inbound_flights))
  
  return(inbound_flights)
}
