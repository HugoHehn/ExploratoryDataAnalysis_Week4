
#### Download zip folder from website and unzip it 

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

temp <- tempfile()
download.file(url,temp, mode = "wb")
unzip(temp, "summarySCC_PM25.rds")
unzip(temp, "Source_Classification_Code.rds")

unlink(temp)


#### Read data from RDS files

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#### Aggregate emissions data by year

EmsYear <- aggregate(NEI$Emissions, by = list(NEI$year), sum)


#### Plot emissions data and save file to PNG

png("plot1.png", width=480, height=480)
plot(EmsYear, type = "o", pch = 15, col = "red", main = "U.S. PM2.5 emissions, 1999-2008", xlab = "Year", ylab = "PM2.5 emissions (tons)", ylim = c(0,7500000))
dev.off()
