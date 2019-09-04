# plot 3

library(chron)

# Loading the Data
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
              temp, method = "curl")
con <- unz(temp, "household_power_consumption.txt")
header <- read.table(con, nrows = 1, header = FALSE, sep =';', stringsAsFactors = FALSE)

# grep the first occurrence of the string "1/2/2007" and will the first line to read
# the numbers of rows are 2 days of data i.e. 60 (min) x 24 (hours) x 2 (days) = 2880
con <- unz(temp, "household_power_consumption.txt")
start <- grep("1/2/2007", readLines(con))[1] -1
ndata <- 60*24*2

con <- unz(temp, "household_power_consumption.txt")
df1 <- read.table(con, sep = ';', 
                  header = FALSE, stringsAsFactors = FALSE, na.strings = "?", 
                  skip = start, 
                  nrows = ndata)

colnames(df1) <- unlist(header)

df1$Date <- as.Date(df1$Date,"%d/%m/%Y")
df1$Time <- times(df1$Time)

# merging Date and Time from the data set to form x axis  
k <- as.POSIXct(paste(df1$Date, df1$Time), format="%Y-%m-%d %H:%M:%S")

png("plot3.png", width = 480, height = 480, units = "px")
plot(k, df1$Sub_metering_1, type = 'l', col = "black", ylab = "Energy Sub Metering", xlab = "")
lines(k,df1$Sub_metering_2,col="red")
lines(k,df1$Sub_metering_3,col="blue")
legend("topright", legend = c("Sub_Metering_1","Sub_Metering_2", "Sub_Metering_3"),
       col = c("black", "red", "blue"), lty =1)
dev.off()

file.remove(temp)