#data download
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
t <- read.table(unz(temp, "household_power_consumption.txt"),header=TRUE,sep=";", na.strings = "?")
unlink(temp)

#date formatting and subsetting:
t$Date <- as.Date(t$Date, "%d/%m/%Y")
t <- subset(t,Date >= as.Date("2007-2-1") & Date <= as.Date("2007-2-2"))
t <- t[complete.cases(t),]
dateTime <- paste(t$Date, t$Time)
dateTime <- setNames(dateTime, "DateTime")
t <- t[ ,!(names(t) %in% c("Date","Time"))]
t <- cbind(dateTime, t)
t$dateTime <- as.POSIXct(dateTime)


#plotting
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(t, {
    plot(Global_active_power~dateTime, type="l", ylab="Global Active Power", xlab="")
    plot(Voltage~dateTime, type="l", xlab = "datetime", ylab="Voltage")
    plot(Sub_metering_1~dateTime, type="l", ylab="Energy sub metering", xlab="")
    lines(Sub_metering_2~dateTime,col='Red')
    lines(Sub_metering_3~dateTime,col='Blue')
    legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
    plot(Global_reactive_power~dateTime, type="l", xlab = "datetime", ylab="Global_reactive_power")
})

#output
dev.copy(png,"plot4.png", width=480, height=480)
dev.off()