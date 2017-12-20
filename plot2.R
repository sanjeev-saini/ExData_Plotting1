
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

# Get power consumption for 2 days in February
# Create a new column DateTime for plotting x axis
my_electricity2days <- my_electricity %>%
                       filter(Date == ymd("2007-02-01")  | Date == ymd("2007-02-02")) %>%
                       mutate(DateTime = as_datetime(paste(Date, 
                                                           Time
                                                     )
                                         )
                       )
                       
# remove the large dataset
rm("my_electricity")

# Line plot for Global Active Power by DateTime
plot(my_electricity2days$DateTime, 
     my_electricity2days$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)"
)


# Copy the plot to png and close the device
dev.copy(png, 
         file = "plot2.png",
         width = 480,
         height = 480
)
dev.off()

# Remove variables
rm("my_electricity2days")

