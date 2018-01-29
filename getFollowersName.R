getLimitFollowers <- function(my_oauth){
  url <- "https://api.twitter.com/1.1/application/rate_limit_status.json"
  params <- list(resources = "followers,application")
  response <- my_oauth$OAuthRequest(URL=url, params=params, method="GET", 
                                    cainfo=system.file("CurlSSL", "cacert.pem", package = "RCurl"))
  return(unlist(rjson::fromJSON(response)$resources$followers$`/followers/ids`[['remaining']]))
}


function (screen_name = NULL,  cursor = -1, user_id = NULL, 
          verbose = TRUE, sleep = 1) 
  {library(twitteR)
#   creds <- list.files(oauth_folder, full.names = T)
#   cr <- sample(creds, 1)
#   if (verbose) {
#     message(cr)
#   }
#   load(cr)
  
  #limit <- getLimitFollowers(credentials1) # credentials1 saved in .renvironment
  limit <- getCurRateLimitInfo()[36,3]
  if (verbose) {
    message(limit, " API calls left")
  }
  if (rate.limit < 100) {
    Sys.sleep(300)
    }
  limit <- getCurRateLimitInfo()[36,3]
  if (verbose) {
    message(limit, " API calls left")
  }
  
  url <- "https://api.twitter.com/1.1/followers/ids.json"
  followers <- c()
  while (cursor != 0) {
    if (!is.null(screen_name)) {
      params <- list(screen_name = screen_name, cursor = cursor, 
                     stringify_ids = "true")
    }
    if (!is.null(user_id)) {
      params <- list(user_id = user_id, cursor = cursor, 
                     stringify_ids = "true")
    }
    url.data <- my_oauth$OAuthRequest(URL = url, params = params, 
                                      method = "GET", cainfo = system.file("CurlSSL", "cacert.pem", 
                                                                           package = "RCurl"))
    Sys.sleep(sleep)
    limit <- limit - 1
    json.data <- rjson::fromJSON(url.data)
    if (length(json.data$error) != 0) {
      if (verbose) {
        message(url.data)
      }
      stop("error! Last cursor: ", cursor)
    }
    followers <- c(followers, as.character(json.data$ids))
    prev_cursor <- json.data$previous_cursor_str
    cursor <- json.data$next_cursor_str
    message(length(followers), " followers. Next cursor: ", 
            cursor)
    if (verbose) {
      message(limit, " API calls left")
    }
    while (limit == 0) {
      cr <- sample(creds, 1)
      if (verbose) {
        message(cr)
      }
      load(cr)
      Sys.sleep(sleep)
      rate.limit <- getLimitRate(my_oauth)
      if (rate.limit < 100) {
        Sys.sleep(300)
      }
      limit <- getLimitFollowers(my_oauth)
      if (verbose) {
        message(limit, " API calls left")
      }
    }
  }
  return(followers)
}
