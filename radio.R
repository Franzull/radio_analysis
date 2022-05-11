install.packages(c("httr", "jsonlite"))
library(httr)
library(jsonlite)

res = GET("http://all.api.radio-browser.info/json/stations")
data = fromJSON(rawToChar(res$content))

country_occurenceCount = table(data$countrycode) # shows amount of stations for each countrycode

# Relative Frequencies

# remove first element since it is shows the stations without country code
country_occurenceCount_withoutFirstValue = country_occurenceCount[-1]

list_occurenceCount = list(country_occurenceCount_withoutFirstValue)
# count all stations that have a countrycode
allStations = sum(country_occurenceCount_withoutFirstValue)

relativeFrequency = lapply(list_occurenceCount, function(x) x/allStations)
relativeFrequency_list = lapply(relativeFrequency, function(x) x*100)

# only display TOP10 Countries, the rest in other
sortedRelativeFrequency = sort(unlist(relativeFrequency_list), decreasing = TRUE)
top10AndOther = sortedRelativeFrequency[1:10]
top10AndOther = c(top10AndOther, setNames(sum(sortedRelativeFrequency[11:length(sortedRelativeFrequency)]),"other"))

lbls = paste(names(top10AndOther), ":", round(top10AndOther), "%")
pie(top10AndOther, main = "Ratio of TOP 10 ", labels = lbls)

    
