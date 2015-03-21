library(dplyr)
library(ggplot2)

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
agg <- pm25 %>% 
       filter(fips == "24510") %>%
       group_by(year, type) %>%
       summarise(Emissions = sum(Emissions))

# Draw the plot.
png("plot3.png", width = 640, height = 480)
print(qplot(year,
            Emissions,
            data = agg,
            color = type,
            geom = c("point",	"smooth")))
dev.off()