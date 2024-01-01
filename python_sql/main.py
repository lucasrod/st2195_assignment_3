from scripts.download_data import DownloadData
from scripts.database_manager import DatabaseManager
from scripts.data_analysis import DataAnalysis

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


def main(orm_backend="sqlite3"):
    # Instantiate classes using imported modules
    downloader = DownloadData()
    database_manager = DatabaseManager(database_path)

    if not database_manager.database_exists():
        print("Downloading Data Expo 2009: Airline Time Dataset\n")
        downloader.download(required_files)
        print(f"Building {database_path}\n")
        database_manager.construct_database(tables_data)
    else:
        print(f"Database {database_path} already exists, skipping setup\n")

    print("Conducting data analysis...\n")
    analyst = DataAnalysis()
    analyst.perform_analysis(database_path)

    print("Assignment 3 completed")


if __name__ == '__main__':
    main()
