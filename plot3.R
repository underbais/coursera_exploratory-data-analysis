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

png('plot3.png', width = 480, height = 480, units = "px")

plot(dat$datetime, dat$Sub_metering_1, 
     xlab = '',
     ylab = 'Energy sub metering',
     type = 'l')
lines(dat$datetime, dat$Sub_metering_2, lty = 1, col = "red")
lines(dat$datetime, dat$Sub_metering_3, lty = 1, col = "blue")
legend("topright", legend = c(names(dat)[7:9]), col = c('black','red','blue'), lty = 1, cex = 0.8)

dev.off()

