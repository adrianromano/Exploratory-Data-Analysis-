## Load and read data
if (!file.exists("Courseradata")) {
    dir.create("Courseradata")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "/Users/adrianromano/Downloads/Courseradata/NEI_data.zip", method = "curl")
if (!file.exists("/Users/adrianromano/Downloads/Courseradata/NEI_data")) {
    unzip(zipfile = "/Users/adrianromano/Downloads/Courseradata/NEI_data.zip", 
          exdir = "/Users/adrianromano/Downloads/Courseradata")
}
NEI <- readRDS("/Users/adrianromano/Downloads/Courseradata/NEI_data/summarySCC_PM25.rds")
SCC <-readRDS("/Users/adrianromano/Downloads/Courseradata/NEI_data/Source_Classification_Code.rds")
str(NEI)
str(SCC)

## Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases and increases in emissions from 1999–2008 for Baltimore City?
library(dplyr)
baltimoreEmissions2 <- NEI %>%
    filter(fips == "24510") %>%
    group_by(year, type) %>%
    summarize(Emissions = sum(Emissions))

png("plot3.png", width = 480, height = 480, bg = "transparent")
library(ggplot2)
ggplot(baltimoreEmissions2, aes(x = factor(year), y = Emissions, fill = type)) +
    geom_bar(stat = "identity", col = "black") +
    facet_grid(. ~ type) +
    xlab("Years") +
    ylab(expression("Total PM"[2.5]*" emissions")) +
    ggtitle (expression("PM"[2.5]*" emissions in Baltimore City, Maryland by Source Type"))
dev.off()