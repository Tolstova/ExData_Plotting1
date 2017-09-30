# This script:
# 1. reads the "PM2.5 Emissions Data Data Set" from the file [./summarySCC_PM25.rds and Source_Classification_Code.rds files]
# 2. extracts the data
# 3. draws a plot showing the Total Emissions from Motor Vehicle Sources in the Baltimore City, Maryland and Los Angeles County
# 4. saves it to "./assignment2_plot6.png" with a width of 480 pixels and a height of 480 pixels
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


plot6 <- function() {
    library(dplyr)
    ## This first line will likely take a few seconds. Be patient!
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")
    SCC <- mutate(SCC, motorvehicle = grepl("vehicle", tolower(as.character(EI.Sector)), ignore.case = TRUE))
    
    data <- merge(SCC, NEI, by.x="SCC", by.y="SCC")
    
    sum_motor_balt <- summarize_by_fips(data, "24510")
    sum_motor_lac <- summarize_by_fips(data, "06037")

    png("C:/GIT/ExData_Plotting1/assignment2_plot6.png", width = 480, height = 480, units = "px")
    par(bg = "transparent")
    options("scipen" = 20)
    plot(x = c(sum_motor_balt[[1]], sum_motor_lac[[1]]), y = (c(sum_motor_balt[[2]], sum_motor_lac[[2]]) * 1.1), ylab = "Total Emissions from Motor Vehicle Sources (tons)", xlab = "Year", type = "n", main = "Total Motor Vehicle Emissions: Baltimore vs Los Angeles County")
    lines(sum_motor_balt, col = "blue")
    lines(sum_motor_lac, col = "red")
    legend("topright", c("Los Angeles County", "Baltimore City"), lty=1, col=c("red", "blue"), cex=.75)
    dev.off()
    message("Drawing assignment2_plot6.png done")
}

summarize_by_fips <- function(full_data, code){
    filtered <- filter(full_data, motorvehicle == TRUE & fips == code)
    grouped <- group_by(select(filtered, Emissions, year), year)
    summarize(grouped, sum(Emissions))
}



