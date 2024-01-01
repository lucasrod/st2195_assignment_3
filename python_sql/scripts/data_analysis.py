import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import sqlite3


class DataAnalysis:
    def __init__(self):
        self.conn = None
        self.output_folder = "output/"
        self.create_output_directory()

    def create_output_directory(self):
        if not os.path.exists(self.output_folder):
            os.makedirs(self.output_folder)

    def perform_analysis(self, db_path):
        self.conn = sqlite3.connect(db_path)

        self.cancelled_flights_by_carrier()

        self.cancelled_flights_rate()
        self.cancelled_flights_rate_2()
        self.avg_dep_delay_by_planes()
        self.inbound_flights_by_cities()

        self.conn.close()

    def execute_query(self, query):
        return pd.read_sql_query(query, self.conn)

    def cancelled_flights_by_carrier(self):
        query = """
        SELECT Description carrier, UniqueCarrier code, COUNT(*) AS cancelled_flights
        FROM ontime o
        JOIN carriers c ON o.UniqueCarrier = c.Code
        WHERE Cancelled = 1 AND UniqueCarrier IN ('UA', 'AA', '9E', 'DL')
        GROUP BY UniqueCarrier, Description
        ORDER BY cancelled_flights DESC
        """
        cancelled_flights = self.execute_query(query)
        print("Company with highest number of cancelled flights\n")
        print(cancelled_flights)
        self.save_to_csv(cancelled_flights, "cancelled_flights.csv")
        self.plot_bar(cancelled_flights, 'carrier', 'cancelled_flights', 'Cancelled Flights by Airline',
                      'cancelled_flights.png')

    def cancelled_flights_rate(self):
        query = """
        SELECT Description carrier, UniqueCarrier code, SUM(Cancelled) / COUNT(*) AS cancel_rate
        FROM ontime o
        JOIN carriers c ON o.UniqueCarrier = c.Code
        WHERE UniqueCarrier IN ('UA', 'AA', '9E', 'DL')
        GROUP BY UniqueCarrier, Description
        ORDER BY cancel_rate DESC
        """
        data = self.execute_query(query)
        print("Company with highest rate of cancelled flights\n")
        print(data)
        self.save_to_csv(data, "cancelled_flights_rate.csv")
        self.plot_bar(data, 'carrier', 'cancel_rate', 'Cancelled Flights Rate by Airline', 'cancelled_flights_rate.png')

    def cancelled_flights_rate_2(self):
        query = """
        SELECT
            q1.Carrier carrier,
            q1.UniqueCarrier code,
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
        """
        data = self.execute_query(query)
        print("Company with highest rate of cancelled flights 2\n")
        print(data)
        self.save_to_csv(data, "cancelled_flights_rate_2.csv")
        self.plot_bar(data, 'carrier', 'cancel_rate', 'Cancelled Flights Rate by Airline 2',
                      'cancelled_flights_rate_2.png')

    def avg_dep_delay_by_planes(self):
        query = """
        SELECT model, AVG(DepDelay) AS avg_delay
        FROM ontime o
        JOIN planes p ON o.tailnum = p.tailnum
        WHERE Cancelled = 0 AND Diverted = 0 AND DepDelay > 0 AND model IN ('737-230', 'ERJ 190-100 IGW', 'A330-223', '737-282')
        GROUP BY model
        ORDER BY avg_delay ASC
        """
        data = self.execute_query(query)
        print("Airplane with lowest average departure delay (in minutes)\n")
        print(data)
        self.save_to_csv(data, "avg_delay.csv")
        self.plot_bar(data, 'model', 'avg_delay', 'Average Departure Delay by Plane Model', 'avg_delay.png')

    def inbound_flights_by_cities(self):
        query = """
        SELECT city, Dest iata_code, COUNT(*) AS inbound_flights
        FROM ontime o
        JOIN airports a ON o.Dest = a.iata
        WHERE Cancelled = 0 AND city IN ('Chicago', 'Atlanta', 'New York', 'Houston')
        GROUP BY city
        ORDER BY inbound_flights DESC
        """
        data = self.execute_query(query)
        print("City with highest number of inbound flights\n")
        print(data)
        self.save_to_csv(data, "inbound_flights.csv")
        self.plot_bar(data, 'city', 'inbound_flights', 'Inbound Flights by City', 'inbound_flights.png')

    def plot_bar(self, data, x, y, title, filename):
        plt.figure(figsize=(10, 6))
        sns.barplot(x=data[x], y=data[y])
        plt.title(title)
        plt.xticks(rotation=45)
        plt.tight_layout()
        plt.savefig(self.output_folder + filename)
        plt.close()

    def save_to_csv(self, data, filename):
        data.to_csv(self.output_folder + filename, index=False)
        print(f"Data saved to {self.output_folder + filename}")

# Example usage
# analyst = DataAnalysis()
# analyst.perform_analysis("database/airline2.db")
