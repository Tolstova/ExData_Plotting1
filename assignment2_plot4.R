# This script:
# 1. reads the "PM2.5 Emissions Data Data Set" from the file [./summarySCC_PM25.rds and Source_Classification_Code.rds files]
# 2. extracts the data
# 3. draws a plot showing the coal combustion-related sources changing from 1999–2008
# 4. saves it to "./assignment2_plot4.png" with a width of 480 pixels and a height of 480 pixels
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


plot4 <- function() {
    library(dplyr)
    ## This first line will likely take a few seconds. Be patient!
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")
    SCC <- mutate(SCC, coal = grepl("coal", tolower(as.character(Short.Name)), ignore.case = TRUE))
    
    data <- merge(SCC, NEI, by.x="SCC", by.y="SCC")
    
    filtered <- filter(data, coal == TRUE)
    by_year <- group_by(select(filtered, Emissions, year), year)

    png("C:/GIT/ExData_Plotting1/assignment2_plot4.png", width = 480, height = 480, units = "px")
    par(bg = "transparent")
    options("scipen" = 20)
    plot(summarize(by_year, sum(Emissions)), ylab = "Total Emissions From Coal Combustion-Related Sources (tons)", xlab = "Year", type = "l", col="red", main = "United States")
    dev.off()
    message("Drawing assignment2_plot4.png done")
}


