
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


#### Subset on SCC short names including the word "coal" and aggregate data by year

SCC$Short.Name <- tolower(SCC$Short.Name)
CoalSub <- SCC[grepl("coal" , SCC$Short.Name), ]

EmsCoal <- NEI[NEI$SCC %in% CoalSub$SCC, ]

EmsCoalyear <- aggregate(EmsCoal$Emissions, list(EmsCoal$year), sum)
names(EmsCoalyear) <- c("Year", "Emissions")


#### Plot emissions data and save file to PNG

library(ggplot2)

png("plot4.png", width=480, height=480)
qplot(x = Year, y = Emissions, data = EmsCoalyear, color = "red", geom= "line")  + 
        geom_point(data = EmsCoalyear) + ylim(0,650000) + theme(legend.position="none") + 
        ggtitle("U.S. PM2.5 emissions from coal, 1999-2008") + 
        ylab("PM2.5 emissions (tons)") + 
        xlab("Year")  
dev.off()


