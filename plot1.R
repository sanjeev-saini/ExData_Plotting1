
#---------------------------------------------------------------------------------------------------------
#   GETTING THE DATASET
#---------------------------------------------------------------------------------------------------------

# Create a directory 'data' to store the dataset
if(!dir.exists("data")){
    dir.create("data")   
}

# Download only if dataset not downloaded previously
if(!file.exists("./data/household_power_consumption.txt")){
    download.file(url = "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip",
              "./data/household_power_consumption.zip",
              mode = "wb")
}

# unzip the downloaded dataset zip file into 'data' folder
if(!file.exists("./data/household_power_consumption.txt")){
    unzip("./data/household_power_consumption.zip",
      exdir = "./data")
}


library(data.table)
library(dplyr)
library(lubridate)

# Read the power consumption dataset
tmp_df <- fread(input = "./data/household_power_consumption.txt",
                  sep = ";",
                  header = TRUE,
                  na.strings = "?",
                  stringsAsFactors = FALSE
          )

# convert to tibble
my_electricity <- as_tibble(tmp_df)

# remove the temp. data.table variable
rm("tmp_df")

# Convert the 'character' class of Date and Time variables to class 'Date' and 'Period'
my_electricity$Date <- dmy(my_electricity$Date)
my_electricity$Time <- hms(my_electricity$Time)

# Get power consumption for 2 days in February
my_electricity2days <- my_electricity %>%
                       filter(Date == ymd("2007-02-01")  | Date == ymd("2007-02-02"))

# remove the large dataset
rm("my_electricity")

# Plot the histogram of Global Active Power
hist(my_electricity2days$Global_active_power,
     col = "red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)"
)


# Copy the plot to png and close the device
dev.copy(png, 
         file = "plot1.png",
         width = 480,
         height = 480
)
dev.off()

# Remove variables
rm("my_electricity2days")

