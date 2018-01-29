# SOCIAL MEDIA EXTRACTION

install.packages("twitteR")
install.packages("rio")

setwd()

library("twitteR")
library("rio")

# authenticate
credentials <- setup_twitter_oauth(consumer_key='YourConsumerKey', consumer_secret='YourConsumerSecret', 
                    access_token='YourAccessToken', access_secret='YourAccessSecret')

# the twitter access token can be stored in your gloabl R environment file. Advantate is that you
# don't need to re-activate it again, as the credentials are loaded every time you open R
# store the file in a secure place
# 
# DOESN'T WORK YET
# ## path of home directory
# home_directory <- path.expand("~/")
# 
# ## combine with name for token
# file_name <- file.path(home_directory, "twitter_token.rds")
# 
# ## save token to home directory
# saveRDS(credentials, file = file_name)
# 
# cat(paste0("TWITTER_PAT=", file_name),
#     file = file.path(home_directory, ".Renviron"),
#     append = TRUE)

# load list of users
institutions <- read.csv("~/Dropbox/repos/future_bus_school/data_sources_final4.csv", header=F)
names(institutions) <- c("country", "name", "length_equis_acc", "equis_accredited", "FBpage", "FBaccountname", "linkedinpage", "comment1", "comment2", "comment3", "comment4", "twitteraccount")
equis <- institutions["equis_accredited" == "yes",]

# connect to twitter

# loop over list 


# live streaming: why, how, backbone

# user timeline:
userTl = userTimeline(userName,n=3200, includeRts = TRUE)

# users with a keyword
users <- search_users(q = 'your query',
                      n = 1000,
                      parse = TRUE)
# matches users name description, screenname or if it is in a tweet that contain the query
library(DT)
datatable(users[, c(2:5)], rownames = FALSE,
          options = list(pageLength = 5))


# twitter search
searchTerm = "Your search term"
tweets = searchTwitter(searchTerm, n=1000, lang = "en")
dfT = twListToDF(tweets)

# get followers & make it in a nice output
lucaspuente <- getUser("lucaspuente")
location(lucaspuente)
lucaspuente_follower_IDs<-lucaspuente$getFollowers(n=1)

if (!require("data.table")) {
  install.packages("data.table", repos="http://cran.rstudio.com/") 
  library("data.table")
}
lucaspuente_followers_df = rbindlist(lapply(lucaspuente_follower_IDs,as.data.frame))
lucaspuente_followers_df<-subset(lucaspuente_followers_df, location!="")




#export #strip out all tabs and new lines from the tweet field 
dfT$tweetC = gsub("\t"," ",dfT$text) 
dfT$tweetC = gsub("\n"," ",dfT$tweetC) 
#add a link to the tweet dfT$linkToTweet = paste("http://twitter.com/",dfT$screenName,"/status/",dfT$id,sep="") 
#strip out the link from the source field 
dfT$sourceC = sub("<a href=\".*\">","",dfT$statusSource) 
dfT$sourceC = sub("</a>","",dfT$sourceC) 
#subset only fields to export 
myvars = c("tweetC","created","linkToTweet","retweetCount","isRetweet","favoriteCount" ,"id","sourceC", "replyToSN", "truncated","replyToSID","replyToUID","screenName","longitude", "latitude") 
dataExport = dfT[myvars] fileName = paste(userName,"-tweets.tsv",sep="") 
export(dataExport,fileName)

# references:
#http://www.ericka.cc/gathering-a-users-posts-from-twitter-with-r/
# putting users on a map: https://www.r-bloggers.com/mapping-twitter-followers-in-r/
# https://d4tagirl.com/2017/05/how-to-fetch-twitter-users-with-r
# https://www.r-bloggers.com/extract-twitter-data-automatically-using-scheduler-r-package/