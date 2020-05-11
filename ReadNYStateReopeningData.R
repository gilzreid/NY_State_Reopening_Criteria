library(tidyverse)

pagedata <- readLines("https://www.governor.ny.gov/where-do-regions-stand")


tabPattern <- "14-Day Decline in&nbsp;Hospitalizations&nbsp;OR&nbsp;"

tableline <- grep(tabPattern, pagedata, value = TRUE)

NYCpattern <- 'New York City([^<]*)North'
NYCpattern1 <- '([^<]*)New York City'
NYCpattern1 <- 'New York City'
NYCpattern2 <- 'North'
htmlpattern <- "</td><td>"

NYCrow <- substring(tableline, regexpr(NYCpattern1, tableline), regexpr(NYCpattern2, tableline) - 1)

result <- gsub(htmlpattern, ';', NYCrow) 

result2 <- gsub("</td></tr><tr><td>", "", result)
resultlist <- strsplit(gsub(htmlpattern, ';', result2), ";")

names(resultlist) <- NULL

NYCData <- do.call(rbind.data.frame, resultlist)
names(NYCData) = c('Region',
                   '14-Day Decline in Hospitalizations OR Under 15 new Hospitalizations (3-day avg)',
                   '14-Day Decline in Hospital deaths OR fewer than 5 deaths (3-day avg)',
                   'New Hospitalizations (Under 2 per 100K residents - 3 day rolling avg)',
                   'Share of total beds available (threshold of 30%)',
                   'Share of ICU beds available (threshold of 30%)',
                   '30 per 1k residents tested monthly (7-day average of new tests per day)',
                   'At least 30 contact tracers per 100K residents',
                   'Metrics Met'
                   )


