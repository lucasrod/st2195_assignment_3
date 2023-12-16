import os
import json
import requests

class DownloadData:
    def __init__(self):
        self.metadata_file = "data/DataExpo2009_AirlineOnTimeData_Metadata_SchemaOrg.jsonld"
        self.data_dir = "data"

    def download(self, required_files):
        # Load the metadata
        with open(self.metadata_file, "r") as f:
            metadata = json.load(f)

        # Get URLs for the required files
        required_distributions = self._filter_metadata_by_filename(metadata, required_files)

        # Download each file
        for dist in required_distributions:
            file_name = dist["name"]
            file_url = dist["contentUrl"]

            destfile = os.path.join(self.data_dir, file_name)

            self._download_file_by_url(file_url, destfile)

    def _filter_metadata_by_filename(self, metadata, required_files):
        # Extract the distribution section
        distributions = metadata["distribution"]

        # Filter distributions to only required files
        required_distributions = [dist for dist in distributions if dist["name"] in required_files]

        return required_distributions

    def _download_file_by_url(self, url, destfile):
        if not os.path.exists(destfile):
            print(f"Downloading: {destfile}")
            response = requests.get(url)

            if response.status_code == 200:
                with open(destfile, "wb") as f:
                    f.write(response.content)
                print(f"File downloaded successfully: {destfile}")
            else:
                print(f"Failed to download file. Status code: {response.status_code}")
        else:
            print(f"File already exists: {destfile}")
