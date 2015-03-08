setwd('C:\\Coursera\\DataScience\\Modules\\ExploratoryDataAnalysis\\week1')
file <- file("household_power_consumption.txt")
df <- read.table(text = grep("^[1,2]/2/2007", readLines(file), value = TRUE), col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), sep = ";", header = TRUE)

df$Date = as.Date(df$Date,"%d/%m/%Y")
df$DateTime <- as.POSIXct(paste(df$Date,df$Time))

# plot 3
png(filename="plot3.png")
with(df, {
  plot(Sub_metering_1 ~ DateTime, type = "l", 
       ylab = "Global Active Power (kilowatts)", xlab = "")
  lines(Sub_metering_2 ~ DateTime, col = 'Red')
  lines(Sub_metering_3 ~ DateTime, col = 'Blue')
})
legend("topright", col = c("black", "red", "blue"), lty = 1, lwd = 2, 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()
