# EXTRACT FOLLOWERS AND FRIENDS FROM EQUIS ACCREDITED UNI

library("twitteR") # this is a compre
library("rtweet")
library("rio")

# authenticate
setup_twitter_oauth(consumer_key='0i2JCz10FhsWrJmgy7iLldVXp', 
                    consumer_secret='nkIgmAQ6at24ydUnm5olrOY64OqJ1fHFwYOVYQ636HvJ1mewSy', 
                    access_token='2220997760-6XDKYaSCv3D0jPJ9XRRG5dhOSzmjwc88llGbUa2', 
                    access_secret='ZIMBaNce0ltCeOooPn9giK3lKPNgmUs78rHHoua09ZoQ8')

## path of home directory
home_directory <- path.expand("~/")

## combine with name for token
file_name <- file.path(home_directory, "twitter_credentials.rds")

## save token to home directory
saveRDS(credentials, file = file_name)

cat(paste0("TWITTER_PAT=", file_name),
    file = file.path(home_directory, ".Renviron"),
    append = TRUE)

# load list of users
institutions <- read.csv("~/Dropbox/repos/future_bus_school/data_sources_final4.csv", header=F, stringsAsFactors = F, encoding="utf-8")
names(institutions) <- c("country", "name", "length_equis_acc", "equis_accredited", "FBpage", "FBaccountname", "linkedinpage", "comment1", "comment2", "comment3", "comment4", "twitteraccount")
#institutions$equis_accredited <- as.factor(institutions$equis_accredited)
equis <- institutions[institutions$equis_accredited == "yes",c(1:4,12)]

# Get data from twitter ---------------------------------------------------

# collect data about users: name, location, number friends etc. 
equis$twitteraccount <- gsub("@", "", equis$twitteraccount)
#equis_tw <- twitteR::lookupUsers(equis$twitteraccount) # get results for several users. use getUser if only 1 user
equis_tw <- rtweet::lookup_users(equis$twitteraccount)

# loop over list 
# get followers & make it in a nice output
# will not retrieve it for all users. 
# TODO : how to take care of very large accoutns (+500 users?)

edgelist <- list()
for (i in 1:nrow(equis_tw)){
  tmp <- rtweet::get_followers(equis_tw$name[i], n = equis_tw$followers_count[i], retryonratelimit = TRUE)
  # create edgelist user - follower
  edgelist[i] <- data.frame(focal <- rep(equis_tw$name[i], nrow(tmp)),
                            followers <- tmp)

}


equis_follower <- lapply(equis_tw, function(x) 
  rtweet::get_followers(x, retryonratelimit = TRUE))

nn_flw <- get_followers(
  equis_follower, n = cnn$followers_count, retryonratelimit = TRUE
)




# transform into dataset --------------------------------------------------

equis_tw2 <- twListToDF(equis_tw)
str(equis_tw2)

# getfollowers id ---------------------------------------------------------




)
equis_tw2$name
equis_tw_followers <- lapply(equis_tw[ ], function(x) x$getFollowers( n = 1))

# # loading library and OAuth token
# library(smappR)
# 
# #load("~/Dropbox/credentials/my_oauth")
# equis_tw2$name
# 
# #returns IDs of followers
# test_followers<-sapply(equis_tw2$name, function(x) getFollowers(x,oauth_folder = "~/Dropbox/credentials", sleep = 60) )
