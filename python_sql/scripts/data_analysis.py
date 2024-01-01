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

        # self.cancelled_flights_rate()
        #
        # self.cancelled_flights_rate_2()
        #
        # self.avg_dep_delay_by_planes()
        #
        # self.inbound_flights_by_cities()

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
        self.plot_bar(cancelled_flights, 'carrier', 'cancelled_flights', 'Cancelled Flights by Airline', 'cancelled_flights.png')

    # def cancelled_flights_rate(self):
    # Similar to cancelled_flights_by_carrier, modify the query and plotting accordingly

    # def cancelled_flights_rate_2(self):
    # Similar to cancelled_flights_by_carrier, modify the query and plotting accordingly

    # def avg_dep_delay_by_planes(self):
    # Similar to cancelled_flights_by_carrier, modify the query and plotting accordingly

    # def inbound_flights_by_cities(self):
    # Similar to cancelled_flights_by_carrier, modify the query and plotting accordingly

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
