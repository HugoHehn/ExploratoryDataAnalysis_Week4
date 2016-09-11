
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


#### Subset data on fips = "24510" and aggregate emissions data by year and type

EmsBL <- subset(NEI, fips == "24510")
EmsBLtype <- aggregate(EmsBL$Emissions, list(EmsBL$type, EmsBL$year), sum)
names(EmsBLtype) <- c("Type", "Year", "Emissions")


#### Plot emissions data and save file to PNG

library(ggplot2)

png("plot3.png", width=480, height=480)
qplot(x = Year, y = Emissions, data = EmsBLtype, color = Type, geom= "line") + 
        geom_point(data = EmsBLtype) + 
        ggtitle("Baltimore City PM2.5 emissions by source, 1999-2008") + 
        ylab("PM2.5 emissions (tons)") + 
        xlab("Year")  
dev.off()  
