setwd('C:\\Coursera\\DataScience\\Modules\\ExploratoryDataAnalysis\\week1')
file <- file("household_power_consumption.txt")
df <- read.table(text = grep("^[1,2]/2/2007", readLines(file), value = TRUE), col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), sep = ";", header = TRUE)

df$Date = as.Date(df$Date,"%d/%m/%Y")
df$DateTime <- as.POSIXct(paste(df$Date,df$Time))

# Plot 1
png(filename="plot1.png")
hist(df$Global_active_power, col = "red", main = paste("Global Active Power"), xlab = "Global Active Power (kilowatts)")
dev.off()
