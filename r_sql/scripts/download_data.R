library(httr)
library(jsonlite)
# This script requires the dataset specification (metadata) json file

# Main function of this, downloads the specified files from the Data Expo 2009 dataset
download_data <- function(required_files){
  # Filter the metadata to get URLs for the required files
  required_distributions = filter_metadata_by_filename("data/DataExpo2009_AirlineOnTimeData_Metadata_SchemaOrg.jsonld", required_files)
  
  # Iterate over the required distributions and download each file
  for (i in 1:nrow(required_distributions)) {
    file_name <- required_distributions$name[i]
    file_url <- required_distributions$contentUrl[i]
    
    # Construct the destination file path
    destfile <- paste0("data/", file_name)
    
    # Download the file using its URL
    download_file_by_url(file_url, destfile)
  }
}

# Filter metadata based on a list of required file names
filter_metadata_by_filename <- function(metadatafile, required_files){
  # Extract the distribution section which contains file URLs and identifiers
  distributions <- fromJSON(metadatafile)$distribution
  
  # Filter distributions to only required files
  required_distributions <- distributions[distributions$name %in% required_files, ]
  
  # The %in% operator checks if elements in the distributions data frame column name are present in vector required_files. It returns a logical vector
  # The logical vector specifies which rows to select, those where the condition is TRUE
  # The blank space after the comma means "select all columns"
  
  # Return the filtered list of distributions
  return(required_distributions)
}

# Function to download a specific file using its URL
download_file_by_url <- function(url, destfile) {
  # Check if the file already exists to avoid unnecessary downloads
  if (!file.exists(destfile)) {
    # Notify the user about the download
    message("Downloading:", destfile)
    response <- GET(url)
    
    # Check if the request was successful
    if (status_code(response) == 200) {
      # Write the content of the response to destination file
      writeBin(content(response, "raw"), destfile)
      message("File downloaded successfully:", destfile)
    } else {
      stop("Failed to download file. Status code:", status_code(response))
    }
  } else {
    cat("File already exists:", destfile, "\n")
  }
}
