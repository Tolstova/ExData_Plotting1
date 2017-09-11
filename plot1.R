# This script:
# 1. reads the "Individual household electric power consumption Data Set" from the file [./household_power_consumption.txt]
# 2. extracts the data regarding household energy usage over a 2-day period in February, 2007 (02/01/2007 and 02/02/2007)
# 3. draws a plot
# 4. saves it to "./plot1.png" with a width of 480 pixels and a height of 480 pixels
setwd("C:/R/4C/data")

# load zipped data  
if (!file.exists("./household_power_consumption.txt")) {
    # download the data
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    zipfile="./power_consumption.zip"
    message("Downloading data")
    download.file(fileURL, destfile=zipfile)
    unzip(zipfile, exdir=".")
}

plot1 <- function() {
    first_line = read.csv(file = "./household_power_consumption.txt", header = TRUE, stringsAsFactors = FALSE, sep = ";", nrows=1)
    household_power_consumption = read.csv(file = "./household_power_consumption.txt", header = FALSE, stringsAsFactors = FALSE, na.strings="?", sep = ";", skip = 66637, nrows = 2880, col.names = tolower(gsub("_", "", names(first_line))))
    png("C:/GIT/ExData_Plotting1/plot1.png", width = 480, height = 480, units = "px")
    par(bg = "transparent")
    hist(household_power_consumption$globalactivepower, col = "orangered", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
    dev.off()
    message("Drawing Plot1.png done")
}