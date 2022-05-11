install.packages(c("httr", "jsonlite"))
library(httr)
library(jsonlite)

res = GET("http://all.api.radio-browser.info/json/stations")
data = fromJSON(rawToChar(res$content))

country_occurenceCount = table(data$countrycode)

# Relative Frequencies

# remove first element since it is shows the stations without country code
country_occurenceCount_withoutFirstValue = country_occurenceCount[-1]

# count all stations that have a country code
allStations = sum(country_occurenceCount_withoutFirstValue)

relativeFrequency_list = lapply(country_occurenceCount_withoutFirstValue, function(x) (x/allStations)*100)

# only display TOP10 Countries, the rest in other
sortedRelativeFrequency = sort(unlist(relativeFrequency_list), decreasing = TRUE)
top10AndOther = sortedRelativeFrequency[1:10]
top10AndOther = c(top10AndOther, setNames(sum(sortedRelativeFrequency[11:length(sortedRelativeFrequency)]),"other"))

# pie chart
lbls = paste(names(top10AndOther), ":", round(top10AndOther), "%")
pie(top10AndOther, main = "Percentages of TOP10 Countries with Most Radio Stations", labels = lbls)


