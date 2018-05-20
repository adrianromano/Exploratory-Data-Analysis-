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

## How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
subsetMotor <- NEI[(NEI$fips == "24510") & (NEI$type == "ON-ROAD"), ]
library(dplyr)
baltimoreEmissions3 <- subsetMotor %>%
    group_by(year) %>%
    summarize(Emissions = sum(Emissions))

png("plot5.png", width = 480, height = 480, bg = "transparent")
ggplot(baltimoreEmissions3, aes(factor(year), Emissions)) +
    geom_bar(stat = "identity", fill = c("bisque", "pink", "aquamarine", "azure"), color = "black") +
    xlab("Years") +
    ylab(expression("Total PM"[2.5]*" emissions")) +
    ggtitle ("Total emissions from motor vehicle in Baltimore City, Maryland")
dev.off()
