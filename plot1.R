#1. Create a R Script with the name plot1.R
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
plot1_data1 <- read.table(data,header=T,sep=";",nrow=2,stringsAsFactors=F,na.strings="?")
nc <- ncol(plot1_data1)

#Reading only the Date column
plot1_data2 <- read.table(data,header=T,sep=";",stringsAsFactors=F,na.strings="?",colClasses=c("character",rep("NULL",nc-1)))

#Converting Date column from character to date.
plot1_data2[,'Date'] <- as.Date(plot1_data2$Date,"%d/%m/%Y")

#subsetting only the required rows
ext_spdate <- plot1_data2$Date == "2007-02-01" | plot1_data2$Date == "2007-02-02"

#converting from T/F to actual row numbers using which.
row_num <- which(ext_spdate)
#reading only the required number of rows
plot1_data3 <- read.table(data,header=T,sep=";",stringsAsFactors=F,na.strings="?",skip=min(row_num)-1,nrows=max(row_num) - min(row_num) + 1)

name <- names(plot1_data1)
names(plot1_data3) <- name

print("Data read complete")
print("Plotting Histogram per specs")
#Plotting histogram per requirement
png("plot1.png",width=480,height=480,units="px")
hist(plot1_data3$Global_active_power,col="red",main="Global Active Power",xlab="Global Active Power(kilowatts)")
dev.off()
wd <- getwd()
print(paste0("Plotting successfull,plot1.png can be found in your working directory ( ", wd ," )"))
