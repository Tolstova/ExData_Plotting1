# This script:
# 1. reads the "Individual household electric power consumption Data Set" from the file [./household_power_consumption.txt]
# 2. extracts the data regarding household energy usage over a 2-day period in February, 2007 (02/01/2007 and 02/02/2007)
# 3. draws a plot
# 4. saves it to "./plot3.png" with a width of 480 pixels and a height of 480 pixels

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

plot3 <- function() {
    set_environment()
    first_line = read.csv(file = "./household_power_consumption.txt", header = TRUE, stringsAsFactors = FALSE, sep = ";", nrows=1)
    household_power_consumption = read.csv(file = "./household_power_consumption.txt", header = FALSE, stringsAsFactors = FALSE, na.strings="?", sep = ";", skip = 66637, nrows = 2880, col.names = tolower(gsub("_", "", names(first_line))))
    household_power_consumption = mutate(household_power_consumption, ts = dmy_hms(paste(date, time, sep = " "), locale = "US"))
    png("C:/GIT/ExData_Plotting1/plot3.png", width = 480, height = 480, units = "px")
    par(bg = "transparent")
    plot(x = household_power_consumption$ts, y = pmax(household_power_consumption$submetering1, household_power_consumption$submetering2, household_power_consumption$submetering3), type="n", ylab = "Energy sub metering", xlab = "")
    lines(x = household_power_consumption$ts, y = household_power_consumption$submetering1, col = "black")
    lines(x = household_power_consumption$ts, y = household_power_consumption$submetering2, col = "red")
    lines(x = household_power_consumption$ts, y = household_power_consumption$submetering3, col = "blue")
    legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=1, col=c("black", "red", "blue"), cex=.75)
    dev.off()
    message("Drawing Plot3.png done")
}



set_environment <- function() {
    Sys.setlocale("LC_TIME", "English")
    library(lubridate)
    library(dplyr)
}


