
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


#### Subset data on fips = "24510" and aggregate emissions data by year

EmsBL <- subset(NEI, fips == "24510")
EmsBLyear <- aggregate(EmsBL$Emissions, by = list(EmsBL$year), sum)


#### Plot emissions data and save file to PNG

png("plot2.png", width=480, height=480)
plot(EmsBLyear, type = "o", pch = 15, col = "red", main = "Baltimore City PM2.5 emissions, 1999-2008", xlab = "Year", ylab = "PM2.5 emissions (tons)", ylim = c(0,4000))
dev.off()
