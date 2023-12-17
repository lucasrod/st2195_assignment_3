import sqlite3
import os
import pandas as pd
import bz2
from chardet import detect

class DatabaseManager:
    def __init__(self, database_path):
        self.database_path = database_path

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
        # Create directory if it doesn't exist
        os.makedirs(os.path.dirname(self.database_path), exist_ok=True)

        # Delete existing database file if present
        if os.path.exists(self.database_path):
            os.remove(self.database_path)

    # Implemented this to avoid encoding errors when pd.read_csv()
    def get_encoding(self, filename):
        # Check if the file is compressed
        if filename.endswith('.bz2'):
            with bz2.open(filename, 'rb') as f:
                return detect(f.read(10000))['encoding']
        else:
            with open(filename, 'rb') as f:
                return detect(f.read(10000))['encoding']

    def _load_table(self, csv_file, table_name):
        encoding = self.get_encoding(csv_file)
        conn = sqlite3.connect(self.database_path)
        print(f"Processing {csv_file} with encoding {encoding}")
        data = pd.read_csv(csv_file, encoding=encoding, low_memory=False)
        data.to_sql(table_name, conn, if_exists='append', index=False)
        print(f"Data from {csv_file} loaded into table {table_name}")
