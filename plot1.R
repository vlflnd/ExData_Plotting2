library(dplyr)

# Read the source data.
codes <- readRDS("Source_Classification_Code.rds")
pm25 <- readRDS("summarySCC_PM25.rds")

# Aggregate total pollution by year.
# The data set is somewhat ambiguous. We assume that the coverage
# of measurements remained consistent over the years. That is the
# percentage of measured pollutant is the same each year.
# We could only compute the pollution across the sources that appear
# in all the years, but that would not account for new pollution
# sources (e.g. new factory built) or retired sources (e.g. coal
# generator decommissioned).
pollution_by_year <- pm25 %>% group_by(year) %>% summarise(Emissions = sum(Emissions))

# Draw the plot.
png("plot1.png")
plot(pollution_by_year,
     type = "b",
     col = 4,
     ylim = c(0, 8e6))
title("Total emission of PM by year")
dev.off()