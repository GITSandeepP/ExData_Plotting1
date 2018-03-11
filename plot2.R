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

png("plot2.png", width = 480, height = 480)

with(hhpc.filterd, plot(datetime, Global_active_power, type = "l", 
                        ylab = "Global Active Power (killowatts)",
                        xlab = ""))

dev.off()