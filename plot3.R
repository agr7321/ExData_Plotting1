## load libraries
library (dplyr)
library (varhandle)
library (lubridate)

## download file, unzip, and read into R
powerUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
powerdest<-"Power consumption"
download.file (powerUrl, powerdest)
powerfiles<-unzip (powerdest)
power<-read.table (powerfiles, sep=";")

## filter for Feb 1st and 2nd, 2007, convert time to POSIT and create table pf
feb1<-filter (power, V1=="1/2/2007")
feb1[,2]<-hms(feb1[,2])
feb2<-filter (power, V1=="2/2/2007")
feb2[,2]<-hms(feb2[,2])
feb2[,2]<-hms(feb2[,2]+ hours (24)) 
pf<-rbind (feb1, feb2)

## rename variables, convert date to POSIT and convert factor data to numeric
pf<-rename (pf, Date=V1, Time=V2, Global_active_power=V3, Global_reactive_power=V4, Voltage=V5, Global_intensity=V6, Sub_metering_1=V7, Sub_metering_2=V8, Sub_metering_3=V9)
pf[,1]<-dmy(pf[,1])
pf_final<-pf
pf_final[,3:9]<-unfactor (pf_final[,3:9])

## draw plot 3
png("plot3.png", width=480, height=480)
plot(pf_final$Time,pf_final$Sub_metering_1, ylab="Energy sub metering", xlab=NA, xaxt='n', pch=NA)
lines(pf_final$Time, pf_final$Sub_metering_1, col="black")
lines(pf_final$Time, pf_final$Sub_metering_2, col="red")
lines(pf_final$Time, pf_final$Sub_metering_3, col="blue")
axis(1, at=c(0, 86400, 172800), labels=c("Thu", "Fri", "Sat"))
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lty=1)
dev.off()