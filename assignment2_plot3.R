# This script:
# 1. reads the "PM2.5 Emissions Data Data Set" from the file [./summarySCC_PM25.rds and Source_Classification_Code.rds files]
# 2. extracts the data
# 3. draws a plot showing the Total PM2.5 Emission (tons) in the Baltimore City organized by sourse
# 4. saves it to "./assignment2_plot3.png" with a width of 480 pixels and a height of 480 pixels
setwd("C:/R/4C/data")

# load zipped data  
if (!file.exists("./summarySCC_PM25.rds")||!file.exists("./Source_Classification_Code.rds")) {
    # download the data
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    zipfile="./exdata_Fdata_FNEI_data.zip"
    message("Downloading data")
    download.file(fileURL, destfile=zipfile)
    unzip(zipfile, exdir=".")
}


plot3 <- function() {
    library(dplyr)
    library(ggplot2)
    ## This first line will likely take a few seconds. Be patient!
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")
    
    data <- merge(SCC, NEI, by.x="SCC", by.y="SCC")
    
    filtered <- filter(data, fips == "24510")
    grouped <- group_by(select(filtered, type, Emissions, year), type, year)
    result <- summarize(grouped, sum(Emissions))
    names(result) <- c("type", "year", "emissions")
    
    sum_balt <- result
    
    png("C:/GIT/ExData_Plotting1/assignment2_plot3.png", width = 480, height = 480, units = "px")
    print(ggplot(data=sum_balt, aes(x=year, y=emissions, group=type, colour=type)) + geom_line() + geom_point() + xlab("Year") + ylab("Total PM2.5 Emissions (tons)") + ggtitle("Total PM2.5 emissions (tons) in the Baltimore, Maryland by source") + scale_colour_hue(name="Source"))

    dev.off()
    message("Drawing assignment2_plot3.png done")
}

