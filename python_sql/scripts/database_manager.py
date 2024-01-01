import bz2
import os
import subprocess
import webbrowser
import time
import sqlite3

import pandas as pd
from chardet import detect


# Implemented to avoid encoding errors when pd.read_csv()
def get_file_encoding(filename):
    # Check if the file is compressed
    if filename.endswith('.bz2'):
        with bz2.open(filename, 'rb') as f:
            return detect(f.read(10000))['encoding']
    else:
        with open(filename, 'rb') as f:
            return detect(f.read(10000))['encoding']


class DatabaseManager:
    def __init__(self, database_path):
        self.database_path = database_path

    def database_exists(self):
        return os.path.exists(self.database_path)

    def serve_datasette(self):
        # Serving the database using Datasette
        print(f"Serving {self.database_path} with Datasette...")
        # Start Datasette in a separate thread or process
        proc = subprocess.Popen(["datasette", self.database_path])

        # Wait for a few seconds to ensure Datasette server starts
        time.sleep(3)

        # Open the default web browser
        webbrowser.open("http://localhost:8001")

        # Keep the script running to serve the Datasette
        try:
            proc.wait()
        except KeyboardInterrupt:
            # Handle Ctrl+C to stop the server
            proc.terminate()

    def construct_database(self, tables_data):
        # Initialize the database
        self._init_database()

        # Create and load tables
        for table_name, csv_files in tables_data.items():
            if isinstance(csv_files, list):
                # Multiple CSV files for "ontime" table
                for csv_file in csv_files:
                    self._load_table(csv_file, table_name)
            else:
                # Single CSV file for other tables
                self._load_table(csv_files, table_name)  # Corrected line

    def _init_database(self):
        # Delete existing database file if present
        if self.database_exists():
            os.remove(self.database_path)
        else:
            os.makedirs(os.path.dirname(self.database_path), exist_ok=True)

    def _load_table(self, csv_file, table_name):
        encoding = get_file_encoding(csv_file)
        conn = sqlite3.connect(self.database_path)
        print(f"Processing {csv_file} with encoding {encoding}")
        data = pd.read_csv(csv_file, encoding=encoding, low_memory=False)
        data.to_sql(table_name, conn, if_exists='append', index=False)
        print(f"Data from {csv_file} loaded into table {table_name}")
