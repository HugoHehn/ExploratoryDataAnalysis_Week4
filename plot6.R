
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


#### Subset on fips "24510" and "06037" and SCC level-two factors including the word "vehicle" 

vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehiclesSCC <- SCC[vehicles,]$SCC
vehiclesNEI <- NEI[NEI$SCC %in% vehiclesSCC,]

VehicleSub <- SCC[grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE),]$SCC
VehicleEms <- NEI[NEI$SCC %in% vehiclesSCC,]

CitiesEms <- VehicleEms[VehicleEms$fips == "24510" | VehicleEms$fips == "06037",]

CitiesEms$City <- CitiesEms$fips
CitiesEms[CitiesEms$fips == "24510", ]$City <- "Baltimore City"
CitiesEms[CitiesEms$fips == "06037", ]$City <- "Los Angeles County"


#### Plot emissions data by year and save file to PNG

library(ggplot2)

png("plot6.png", width=1040, height=480)
ggplot(CitiesEms, aes(factor(year), Emissions)) + 
        facet_grid(. ~ City) + 
        geom_bar(aes(fill = City), stat="identity")  +
        ggtitle("PM2.5 emissions from motor vehicles, 1999-2008") +
        xlab("Year") +
        ylab("PM2.5 emissions (tons)") +
        theme(legend.position="none")
dev.off()



