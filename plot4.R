#1. Create a R Script with the name plot4.R
# Check if required datafile - household_power_consumption.txt exists, if not download and unzip
#--------------------------------------------------------------------------------------
if(file.exists("household_power_consumption.txt")==FALSE)
{
  link <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  print("Please wait, the file being downloaded is about ~20MB compressed")
  download.file(link,destfile="./power_consumption_data.zip")
  unzip("power_consumption_data.zip")
  unlink("power_consumption_data.zip", recursive = T)
  print("Download Complete.")
}else {
  print("household_power_consumption.txt already exists in working directory, proceeding using this dataset")
}
#--------------------------------------------------------------------------------------

#Reading only 2 rows from the dataset as there are large number of rows.
print("Subsetting required data, 2M rows to be processed, please wait")
data <- "./household_power_consumption.txt"
plot4_data1 <- read.table(data,header=T,sep=";",nrow=2,stringsAsFactors=F,na.strings="?")
nc <- ncol(plot4_data1)

#Reading only the Date column
plot4_data2 <- read.table(data,header=T,sep=";",stringsAsFactors=F,na.strings="?",colClasses=c("character",rep("NULL",nc-1)))

#Converting Date column from character to date.
plot4_data2[,'Date'] <- as.Date(plot4_data2$Date,"%d/%m/%Y")

#subsetting only the required rows
ext_spdate <- plot4_data2$Date == "2007-02-01" | plot4_data2$Date == "2007-02-02"

#converting from T/F to actual row numbers using which.
row_num <- which(ext_spdate)
#reading only the required number of rows
plot4_data3 <- read.table(data,header=T,sep=";",stringsAsFactors=F,na.strings="?",skip=min(row_num)-1,nrows=max(row_num) - min(row_num) + 1)

name <- names(plot4_data1)
names(plot4_data3) <- name

datetime <- paste(plot4_data3$Date,plot4_data3$Time)
plot4_data4 <- cbind(plot4_data3,datetime,stringsAsFactors=F)

datetime2 <- strptime(plot4_data4$datetime,"%d/%m/%Y  %H:%M:%S")
plot4_data5 <- cbind(plot4_data4,datetime2,stringsAsFactors=F)


print("Data read complete")

png("plot4.png",width=480,height=480,units="px")

#Setting 2,2 area - 2 rows, 2 columns
par(mfrow=c(2,2))
print("Plotting Chart1 per specs")
#Plotting Line Chart1 per requirement
plot(plot4_data5$Global_active_power ~ plot4_data5$datetime2,type="n",ylab="Global Active Power",xlab="")
axis(side=2,lwd=2,labels=F)
lines(plot4_data5$datetime2,plot4_data5$Global_active_power)

#Plotting Line Chart2 per requirement
plot(plot4_data5$Voltage ~ plot4_data5$datetime2,type="n",ylab="Voltage",xlab="datetime",cex.axis = 0.9, cex.lab = 0.9)
axis(side=2,lwd=2,labels=F)
lines(plot4_data5$datetime2,plot4_data5$Voltage)

#Plotting Line Chart3 per requirement
plot(plot4_data5$Sub_metering_1 ~ plot4_data5$datetime2,type="n",ylab="Energy sub metering",xlab="",cex.axis = 0.9, cex.lab = 0.9)
axis(side=2,lwd=2,labels=F)
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"),lwd=1,bty="n",pt.cex = 1,cex=0.9)

lines(plot4_data5$datetime2,plot4_data5$Sub_metering_1,col="black")
lines(plot4_data5$datetime2,plot4_data5$Sub_metering_2,col="red")
lines(plot4_data5$datetime2,plot4_data5$Sub_metering_3,col="blue")

#Plotting Line Chart4 per requirement

plot(plot4_data5$Global_reactive_power ~ plot4_data5$datetime2,type="n",ylab="Global_reactive_power",xlab="datetime",cex.axis = 0.9, cex.lab = 0.9)
axis(side=2,lwd=2,labels=F)
lines(plot4_data5$datetime2,plot4_data5$Global_reactive_power)

dev.off()
wd <- getwd()
print(paste0("Plotting successfull,plot4.png can be found in your working directory ( ", wd ," )"))
