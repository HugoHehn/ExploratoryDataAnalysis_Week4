
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


#### Subset on fips = "24510" and SCC level-two factors including the word "vehicle" and aggregate data by year

EmsBL <- subset(NEI, fips == "24510")

SCC$SCC.Level.Two <- tolower(SCC$SCC.Level.Two)

VehicleSub <- SCC[grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE),]$SCC
VehicleBL <- EmsBL[EmsBL$SCC %in% VehicleSub,]

EmsBLvehicle <- aggregate(VehicleBL$Emissions, list(VehicleBL$year), sum)
names(EmsBLvehicle) <- c("Year", "Emissions")


#### Plot emissions data and save file to PNG

library(ggplot2)

png("plot5.png", width=480, height=480)
qplot(x = Year, y = Emissions, data = EmsBLvehicle, color = "red", geom= "line")  + 
        geom_point(data = EmsBLvehicle) + ylim(0,450) + theme(legend.position="none") + 
        ggtitle("Baltimore City PM2.5 emissions from motor vehicles, 1999-2008") + 
        ylab("PM2.5 emissions (tons)") + 
        xlab("Year")  
dev.off()