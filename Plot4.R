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

## Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
NEISCC <- merge(NEI, SCC, by = "SCC")
coal <- grepl("coal", NEISCC$Short.Name, ignore.case = TRUE)
subsetCoal <- NEISCC[coal, ]

library(dplyr)
coalEmissions <- subsetCoal %>%
    group_by(year) %>%
    summarize(Emissions = sum(Emissions))

png("plot4.png", width = 480, height= 480, bg = "transparent")
ggplot(coalEmissions, aes(factor(year), Emissions)) +
    geom_bar(stat = "identity", fill = c("magenta", "yellow", "orange", "linen"), col = "black") +
    xlab("Years") +
    ylab(expression("Total PM"[2.5]*" emissions")) +
    ggtitle ("Emissions from coal combustion-related sources")
dev.off()
