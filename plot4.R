library(dplyr)
library(lubridate)

#loading data 

zipfile = 'household_power_consumption.zip'
file = 'household_power_consumption.txt'


if (!file.exists(zipfile)) {
  
  temp <- tempfile()
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
  dat <- read.table(unz(temp, file), header = TRUE, sep = ';', stringsAsFactors = FALSE)
  unlink(temp)

} else {
  dat <- read.table(unz(zipfile,file), header = TRUE, sep = ';', stringsAsFactors = FALSE, na.strings = '?')
}

#subsetting data

dat <- as.data.frame(dat)
dat <- dat %>% mutate(datetime = paste(dat$Date,dat$Time,sep = ' '))
dat <- dat %>% mutate(datetime = dmy_hms(datetime)) 
dat <- dat %>% filter(datetime > as.Date('2007-02-01') & datetime < as.Date('2007-02-03') )


#plotting data

png('plot4.png', width = 480, height = 480, units = "px")

par(mfrow=c(2,2))

#first panel

plot(dat$datetime, dat$Global_active_power, 
     xlab = '',
     ylab = 'Global Active Power',
     type = 'l')

#second panel

plot(dat$datetime, dat$Voltage, 
     xlab = 'datetime',
     ylab = 'Voltage',
     type = 'l')

#third panel

plot(dat$datetime, dat$Sub_metering_1, 
     xlab = '',
     ylab = 'Energy sub metering',
     type = 'l')
lines(dat$datetime, dat$Sub_metering_2, lty = 1, col = "red")
lines(dat$datetime, dat$Sub_metering_3, lty = 1, col = "blue")
legend("topright", legend = c(names(dat)[7:9]), col = c('black','red','blue'), lty = 1, cex = 0.8, bty = 'n')

#fourth panel

plot(dat$datetime, dat$Global_reactive_power, 
     xlab = 'datetime',
     ylab = 'Global_reactive_power',
     type = 'l')

dev.off()

