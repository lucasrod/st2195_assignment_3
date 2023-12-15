# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.


def main():
    # Use a breakpoint in the code line below to debug your script.
    # Define some initial values for the dataset and database files
    required_files = [
        "2000.csv.bz2", "2001.csv.bz2", "2002.csv.bz2",
        "2003.csv.bz2", "2004.csv.bz2", "2005.csv.bz2",
        "airports.csv", "carriers.csv", "plane-data.csv"
    ]

    database_path = "database/airline2.db"

    # Define table names and corresponding CSV file paths
    tables_data = {
        "ontime": ["data/2000.csv.bz2", "data/2001.csv.bz2",
                   "data/2002.csv.bz2", "data/2003.csv.bz2",
                   "data/2004.csv.bz2", "data/2005.csv.bz2"],
        "airports": "data/airports.csv",
        "carriers": "data/carriers.csv",
        "planes": "data/plane-data.csv"
    }

    # Execute the workflow
    print("Downloading Data Expo 2009: Airline Time Dataset\n") # Press ⌘F8 to toggle the breakpoint.
    download_data.download(required_files)

    # Build SQLite db file and tables
    if not os.path.exists(database_path):
        print(f"Building {database_path}\n")
        construct_db.init_db(database_path)

        # Load the actual data
        print("Loading the data\n")
        construct_db.load_data(database_path, tables_data)

    print("Executing queries...\n")
    queries_sqlite.execute_queries(database_path)
    queries_orm.execute_queries(database_path)

    print("Assignment 3 completed\n")


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    main()

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
