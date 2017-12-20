
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

# Open a png graphic device
png(file = "plot4.png",
    width = 480,
    height = 480
)

# set global parameter to plot 2 rows and 2 cols.
par(mfrow = c(2,2)#,
    # mar = c("bottom" = 2, "left" = 2, "top" = 2, "right" = 2),
    # oma = c(1, 1, 0, 1)
)

# 1st plot
# Line plot for Global Active Power by DateTime
plot(my_electricity2days$DateTime, 
     my_electricity2days$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power"
)

# 2nd plot
# Line plot for Voltage by DateTime
plot(my_electricity2days$DateTime, 
     my_electricity2days$Voltage,
     type = "l",
     xlab = "datetime",
     ylab = "Voltage"
)

# 3rd plot
# Line plot for Energy Sub metering by DateTime
with(my_electricity2days,
     plot(DateTime,
          Sub_metering_1,
          type = "n",
          xlab = "",
          ylab = "Energy sub metering"
     )
)

# Annotate Sub_metering_1 to plot
with(my_electricity2days,
     lines(DateTime,
           Sub_metering_1,
           col = "black"
     )
)

# Annotate Sub_metering_2 to plot
with(my_electricity2days,
     lines(DateTime,
           Sub_metering_2,
           col = "red"
     )
)

# Annotate Sub_metering_3 to plot
with(my_electricity2days,
     lines(DateTime,
           Sub_metering_3,
           col = "blue"
     )
)

# Annotate legend to plot
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lwd = c("1", "1", "1"), 
       col = c("black", "red", "blue")
)

# 4th plot
# Line plot for Global Reactive Power by DateTime
plot(my_electricity2days$DateTime, 
     my_electricity2days$Global_reactive_power,
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power"
)

# Turn off graphic device
dev.off()

# Remove variables
rm("my_electricity2days")

