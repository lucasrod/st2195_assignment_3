# download_data.R
library(httr)

# Function to download a specific file using its persistent ID
download_file_by_id <- function(api_token, server_url, persistent_id, destfile) {
  # Check if the file already exists
  if (!file.exists(destfile)) {
    # Construct the API endpoint for a specific file
    api_endpoint <- sprintf("%s/api/access/datafile/:persistentId?persistentId=%s", 
                            server_url, persistent_id)
    
    # Make the API request
    response <- GET(api_endpoint, add_headers(`X-Dataverse-key` = api_token))
    
    # Check if the request was successful
    if (status_code(response) == 200) {
      # Write the content of the response to a file
      writeBin(content(response, "raw"), destfile)
      message("File downloaded successfully: ", destfile)
    } else {
      stop("Failed to download file. Status code: ", status_code(response))
    }
  } else {
    message("File already exists: ", destfile)
  }
}

# Persistent IDs for each file
api_token <- "b3fc0526-7156-4fd9-bea4-c88a233364ef"
server_url <- "https://dataverse.harvard.edu"

plane_data_id <- "doi:10.7910/DVN/HG7NV7/XXSL8A"
carriers_id <- "doi:10.7910/DVN/HG7NV7/3NOQ6Q"
airports_id <- "doi:10.7910/DVN/HG7NV7/XTPZZY"

yearly_files <- list(
  "2000" = "doi:10.7910/DVN/HG7NV7/YGU3TD",
  "2001" = "doi:10.7910/DVN/HG7NV7/CI5CEM",
  "2002" = "doi:10.7910/DVN/HG7NV7/OWJXH3",
  "2003" = "doi:10.7910/DVN/HG7NV7/KM2QOA",
  "2004" = "doi:10.7910/DVN/HG7NV7/CCAZGT",
  "2005" = "doi:10.7910/DVN/HG7NV7/JTFT25"
)

# Check if the 'data' directory exists; create it if not
if (!dir.exists("data")) {
  dir.create("data")
}

# Download each file
download_file_by_id(api_token, server_url, plane_data_id, "data/plane_data.csv")
download_file_by_id(api_token, server_url, carriers_id, "data/carriers.csv")
download_file_by_id(api_token, server_url, airports_id, "data/airports.csv")
for (year in names(yearly_files)) {
  persistent_id <- yearly_files[[year]]
  destfile <- paste0("data/", year, ".csv.bz2")
  download_file_by_id(api_token, server_url, persistent_id, destfile)
}