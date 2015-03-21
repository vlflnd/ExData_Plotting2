library(dplyr)
library(ggplot2)

# Read the source data.
codes <- readRDS("Source_Classification_Code.rds")
pm25 <- readRDS("summarySCC_PM25.rds")

# Combine the two tables by source code.
#
# The data set is somewhat ambiguous. We assume that the coverage
# of measurements remained consistent over the years. That is the
# percentage of measured pollutant is the same each year.
# We could only compute the pollution across the sources that appear
# in all the years, but that would not account for new pollution
# sources (e.g. new factory built) or retired sources (e.g. coal
# generator decommissioned).
#
# The definition of whether the source comes from a motor vehicle
# is ambiguous in the data set. We assume that EI.Sector column
# will contain the word "vehicle" for these sources. We assume
# that non-motor vehicles (such as horses) have negligible effect
# on pollution of PM.
merged <- merge(pm25, codes, by = "SCC")

# Aggregate total pollution by year.
agg <- merged %>% 
       filter(fips == "24510") %>%
       filter(grepl("vehicle", EI.Sector, ignore.case = TRUE)) %>%
       group_by(year) %>%
       summarise(Emissions = sum(Emissions))

# Draw the plot.
png("plot5.png")
print(qplot(year,
            Emissions,
            data = agg,
            geom = c("point", "smooth")))
dev.off()