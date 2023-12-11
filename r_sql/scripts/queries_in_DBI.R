# Function for each specific query using DBI
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
  WHERE UniqueCarrier IN ('UA', 'AA', '9E', 'DL')
  GROUP BY UniqueCarrier, Description
  ORDER BY cancel_rate DESC
  "
  execute_query(conn, query)
}

get_cancelled_flights_rate_2 <- function(conn) {
  query <- "
  SELECT
    q1.Carrier,
    q1.UniqueCarrier,
    (CAST(q1.CancelCount AS FLOAT) / CAST(q2.TotalFlights AS FLOAT)) AS cancel_rate
  FROM
    (SELECT
      c.Description AS Carrier,
      c.Code AS UniqueCarrier,
      COUNT(*) AS CancelCount
      FROM carriers c
        JOIN ontime o ON o.UniqueCarrier = c.Code
      WHERE o.Cancelled = 1
        AND c.Description IN ('United Air Lines Inc.', 'American Airlines Inc.', 'Pinnacle Airlines Inc.', 'Delta Air Lines Inc.')
      GROUP BY c.Description, c.Code
    ) AS q1
  JOIN
    (SELECT
        c.Description AS Carrier,
        COUNT(*) AS TotalFlights
      FROM carriers c
        JOIN ontime o ON o.UniqueCarrier = c.Code
      WHERE c.Description IN ('United Air Lines Inc.', 'American Airlines Inc.', 'Pinnacle Airlines Inc.', 'Delta Air Lines Inc.')
      GROUP BY c.Description
    ) AS q2 ON q1.Carrier = q2.Carrier
  ORDER BY cancel_rate DESC
  "
  execute_query(conn, query)
}

get_avg_dep_delay_by_planes<- function(conn) {
  query <- "
  SELECT model, AVG(DepDelay) AS avg_delay
  FROM ontime o
  JOIN planes p ON o.tailnum = p.tailnum
  WHERE Cancelled = 0 AND Diverted = 0 AND DepDelay > 0 AND model IN ('737-230', 'ERJ 190-100 IGW', 'A330-223', '737-282')
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
  WHERE Cancelled = 0 AND city IN ('Chicago', 'Atlanta', 'New York', 'Houston')
  GROUP BY city
  ORDER BY inbound_flights DESC
  "
  execute_query(conn, query)
}