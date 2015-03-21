library(dplyr)
library(ggplot2)

# Read the source data.
codes <- readRDS("Source_Classification_Code.rds")
pm25 <- readRDS("summarySCC_PM25.rds")

# Combine the two tables by source code.
merged <- merge(pm25, codes, by = "SCC")

# Aggregate total pollution by year.
#
# The data set is somewhat ambiguous. We assume that the coverage
# of measurements remained consistent over the years. That is the
# percentage of measured pollutant is the same each year.
# We could only compute the pollution across the sources that appear
# in all the years, but that would not account for new pollution
# sources (e.g. new factory built) or retired sources (e.g. coal
# generator decommissioned).
#
# The definition of the sources does not clearly define whether a
# pollution source is coal based. We assume that coal base sources
# will have the word "coal" in EI.Sector column.
agg <- merged %>% 
       filter(grepl("coal", EI.Sector, ignore.case = TRUE)) %>%
       group_by(year) %>%
       summarise(Emissions = sum(Emissions))

# Draw the plot.
png("plot4.png")
print(qplot(year,
            Emissions,
            data = agg,
            geom = c("point", "smooth")))
dev.off()