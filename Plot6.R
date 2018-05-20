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

## Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California.
subsetMotor2 <- NEI[(NEI$fips == "24510" | NEI$fips == "06037") & (NEI$type == "ON-ROAD"), ]
library(dplyr)
baltimoreLAEmissions <- subsetMotor2 %>%
    group_by(year, fips) %>%
    summarize(Emissions = sum(Emissions))
baltimoreLAEmissions$fips[baltimoreLAEmissions$fips == "24510"] <- "Baltimore City, MD"
baltimoreLAEmissions$fips[baltimoreLAEmissions$fips == "06037"] <- "Los Angeles, CA"

png("plot6.png", width = 600, height = 480, bg = "transparent")
ggplot(baltimoreLAEmissions, aes(factor(year), Emissions, fill = fips)) + 
    geom_bar(stat = "identity", color = "black") +
    facet_grid(. ~ fips) +
    xlab("Years") +
    ylab(expression('Total PM'[2.5]*" emissions")) +
    ggtitle("Total Emissions from motor vehicle in Baltimore City, MD vs Los Angeles, CA") 
dev.off()