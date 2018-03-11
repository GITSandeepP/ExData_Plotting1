# Load required libraries
library(sqldf)
library(dplyr)

# Set Main directory path
maindir <- "/Users/mycomputer"
# Set Working directory path
path <- paste(maindir, "/Documents", sep = "")

# Check if desired working directory path exist or not
# if exist then set working directory else create directory and set it accordingly
if (dir.exists(file.path(path))){
        setwd(file.path(path))
}else {
        dir.create(file.path(maindir, "Documents"))
        setwd(file.path(path))
}

# Download the dataset to work on
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileurl, destfile = "Householdpowerconsumption.zip")

# As the dataset is in zip folder, unzip command is used to unzip the file
zipf <- paste(path, "/Householdpowerconsumption.zip", sep = "")
outdir <- paste(path, "/Householdpowerconsumption", sep = "")
unzip(zipf, exdir = outdir)

filepath <- paste(outdir, "/household_power_consumption.txt", sep = "")

hhpc <- read.table(filepath, na.strings = "?",
                   header = TRUE, sep = ";", stringsAsFactors = FALSE)

hhpc$Date <- as.Date(hhpc$Date, "%d/%m/%Y")

hhpc <- hhpc[complete.cases(hhpc),]

hhpc.filterd <- hhpc %>% 
        filter(Date >= "2007-02-01" & Date <= "2007-02-02") %>% 
        filter(Global_active_power != "?")

datetime <- paste(hhpc.filterd$Date, hhpc.filterd$Time, sep = " ")

hhpc.filterd <- cbind(datetime, hhpc.filterd)

hhpc.filterd$datetime <- as.POSIXct(datetime)

png("plot4.png", width = 480, height = 480)

par(mfrow = c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))

with(hhpc.filterd, plot(datetime, Global_active_power, type = "l", 
                        ylab = "Global Active Power",
                        xlab = ""))

with(hhpc.filterd, plot(datetime, Voltage, type = "l", 
                        ylab = "Voltage",
                        xlab = "datetime"))

with(hhpc.filterd, plot(datetime, Sub_metering_1, type = "n", 
                        ylab = "Energy sub metering",
                        xlab = ""))
lines(hhpc.filterd$date, hhpc.filterd$Sub_metering_1, type = "l", col = "black")
lines(hhpc.filterd$date, hhpc.filterd$Sub_metering_2, type = "l", col = "red")
lines(hhpc.filterd$date, hhpc.filterd$Sub_metering_3, type = "l", col = "blue")
legend("topright", col = c("black", "red", "blue"), lty=1, lwd=2, bty="n",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       cex = 0.85)

with(hhpc.filterd, plot(datetime, Global_reactive_power, type = "l", 
                        ylab = "Global_reactive_power",
                        xlab = "datetime"))

dev.off()