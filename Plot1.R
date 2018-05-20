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

## Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
library(dplyr)
pm25TotalEmissions <- NEI %>%
    group_by(year) %>%
    summarize(Emissions = sum(Emissions))

png("plot1.png", width = 480, height = 480, bg = "transparent")
barplot(pm25TotalEmissions$Emissions, names.arg = pm25TotalEmissions$year,
        xlab = "Years", ylab = expression("Total PM"[2.5]*" emissions"),
        main = expression("Total PM"[2.5]*" emissions for the years"),
        col = c("bisque", "pink", "aquamarine", "azure"))
dev.off()