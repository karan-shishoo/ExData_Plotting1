file.name <- "./household_power_consumption.txt"
download.url       <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zip.name  <- "./data.zip"

# Check if the data is downloaded and download when applicable
if (!file.exists(file.name)) {
  download.file(download.url, destfile = zip.name)
  unzip(zip.name)
  file.remove(zip.name)
}

# Reading the file
library(data.table)
DT <- fread(file.name,
            sep = ";",
            header = TRUE,
            colClasses = rep("character",9))

# Changing all the '?' to 'NA'
DT[DT == "?"] <- NA

# Selecting the needed rows
DT$Date <- as.Date(DT$Date, format = "%d/%m/%Y")
DT <- DT[DT$Date >= as.Date("2007-02-01") & DT$Date <= as.Date("2007-02-02"),]

# Joining day and time for format
DT$posix <- as.POSIXct(strptime(paste(DT$Date, DT$Time, sep = " "),
                                format = "%Y-%m-%d %H:%M:%S"))

# setting class of needed column
DT$Global_active_power <- as.numeric(DT$Global_active_power)

# Plotting the graph
png(file = "plot2.png", width = 480, height = 480, units = "px")
with(DT,
     plot(posix,
          Global_active_power,
          type = "l",
          xlab = "",
          ylab = "Global Active Power (kilowatts)"))
# Closing the png file device
dev.off()
