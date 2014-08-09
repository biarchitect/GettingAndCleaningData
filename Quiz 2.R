#Getting And Cleaning Data
#Quiz 2
#Question 1
library(httr)
library(jsonlite)


# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
github<-oauth_endpoints("github")

# 2. Register an application at https://github.com/settings/applications
#    Insert your values below - if secret is omitted, it will look it up in
#    the GITHUB_CONSUMER_SECRET environmental variable.
#
#    Use http://localhost:1410 as the callback url
setInternet2(TRUE)
clientID<-"f138d88b3932bf7e28df"
clientSecret<-"d66db2cdaa575ae2c9fc6114c66030bf20d0406e"
url<-"https://api.github.com/users/jtleek/repos"
myapp <- oauth_app("github",key="f138d88b3932bf7e28df",secret="d66db2cdaa575ae2c9fc6114c66030bf20d0406e")
github_token <- oauth2.0_token(github, myapp)
gtoken <- config(token = github_token)
req <- GET(url, gtoken)
stop_for_status(req)
jsonx<-content(req)
json2<-jsonlite::fromJSON(jsonlite::toJSON(jsonx))
names(json2)
json2$name
json2$name[5]
json2$created_at[5]

# sig<-sign_oauth1.0(myapp,token=clientID,token_secret=clientSecret)
# homeTL<-GET(url,sig,verbose())
# 
# req <- GET("http://api.github.com/users/jtleek/repos",verbose(), github_token)

#Question 4
url<-"http://biostat.jhsph.edu/~jleek/contact.html"
c(nchar(readLines(url)[10]),nchar(readLines(url)[20]),nchar(readLines(url)[30]),nchar(readLines(url)[100]))

#Question 5
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"


