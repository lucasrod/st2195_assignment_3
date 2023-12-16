# Import from separate scripts for modularity
from scripts.download_data import DownloadData
# from scripts.database_manager import DatabaseManager
# from scripts.data_analysis import DataAnalysis
# from scripts.query_executor import QueryExecutor, SQLiteQueryExecutor, ORMQueryExecutor

# Define initial values for dataset and database
required_files = [
    "2000.csv.bz2", "2001.csv.bz2", "2002.csv.bz2",
    "2003.csv.bz2", "2004.csv.bz2", "2005.csv.bz2",
    "airports.csv", "carriers.csv", "plane-data.csv"
]
database_path = "database/airline2.db"
tables_data = {
    "ontime": ["data/" + filename for filename in required_files[:6]],
    "airports": "data/airports.csv",
    "carriers": "data/carriers.csv",
    "planes": "data/plane-data.csv"
}
# Default db library sqlite3
def main(orm_backend="sqlite3"):
    # Instantiate classes using imported modules
    downloader = DownloadData()
    # db_manager = DatabaseManager(database_path)
    # analyst = DataAnalysis()

    # Choose and instantiate the appropriate QueryExecutor subclass based on orm_backend
    # query_executor_classes = {
    #     "sqlite3": SQLiteQueryExecutor,
    #     "ponyorm": ORMQueryExecutor
    # }

    # Choose and instantiate QueryExecutor subclass based on orm_backend
    # query_executor = query_executor_classes[orm_backend](database_path)


    # Workflow execution with error handling
    try:
        print("Downloading Data Expo 2009: Airline Time Dataset\n")
        downloader.download(required_files)
        #
        # print(f"Building {database_path}\n")
        # db_manager.construct_database(tables_data)
        #
        # print("Executing queries...\n")
        # query_executor.execute_queries()
        #
        # print("Conducting data analysis...\n")
        # analyst.perform_analysis()
        #
        # print("Assignment 3 completed")
    except Exception as e:
        print(f"Error: {e}")

# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    main()
