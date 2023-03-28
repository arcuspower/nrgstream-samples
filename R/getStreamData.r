install.packages("httr")
library("httr")

# Authenticate first
authenticateForm="grant_type=password&username=myUserName&password=myPassword"
authResponse <- POST("https://api.nrgstream.com/api/security/token", body=authenticateForm )
if (authResponse$status_code != 200) {
  stop("Authentication failed")
}

token <- content(authResponse)$access_token
authHeaderContent = paste("Bearer", token, sep=" ")

# Ask api for stream data
dataResponse <- GET("https://api.nrgstream.com/api/StreamData/2?fromDate=2022-12-10%2015:00:00&toDate=2022-12-12%2015:00:00", add_headers(Authorization=authHeaderContent) )
if (dataResponse$status_code != 200) {
  stop("Data fetch failed")
}
rawNrgData <- content(dataResponse)$data

releaseResponse <- DELETE("https://api.nrgstream.com/api/ReleaseToken", add_headers(Authorization=authHeaderContent) )
if (releaseResponse$status_code != 200) {
  stop("Token release has failed")
}

# One method to repack the data into a data frame
timestamps <- unlist(lapply(rawNrgData, function(row) row[1]))
values <- unlist(lapply(rawNrgData, function(row) row[2]))
df <- data.frame(timestamp=timestamps, value=values)
