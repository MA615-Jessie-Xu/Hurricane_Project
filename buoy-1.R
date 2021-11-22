library(tidyverse)
library(magrittr)
library(lubridate)


#Here is the Measurement description: https://www.ndbc.noaa.gov/measdes.shtml#stdmet


#Only 42019, 42035 and SRST2 were significantly influenced by Humberto.44013

# These three datasets are Standard Meteorological Data
#https://www.ndbc.noaa.gov/download_data.php?filename=42019h2007.txt.gz&dir=data/historical/stdmet/
#https://www.ndbc.noaa.gov/download_data.php?filename=42035h2007.txt.gz&dir=data/historical/stdmet/
#https://www.ndbc.noaa.gov/download_data.php?filename=srst2h2007.txt.gz&dir=data/historical/stdmet/

buoys_id <- c("42019", "42035", "SRST2")
buoys_id %<>% tolower() 
url1 <-  "https://www.ndbc.noaa.gov/view_text_file.php?filename="
url2 <- ".txt.gz&dir=data/historical/stdmet/"
urls <- str_c(url1,buoys_id, "h2007", url2, sep = "")
filenames <- str_c("dt_", buoys_id, sep = "")
year = 2007
month = as.integer(file$MM)
day = as.integer(file$DD)
hour = as.integer(file$hh)
min = as.integer(file$mm)

N <- length(urls)

for (i in 1:N){
  suppressMessages(  ###  This stops the annoying messages on your screen.
   file <- read_table(urls[i], col_names = TRUE)
  )
   file$date_time <- make_datetime(year = 2007, month = as.integer(file$MM), day = as.integer(file$DD), hour = as.integer(file$hh), min = as.integer(file$mm))
  
   file <- file[file$date_time>"2007-09-06 0:0:00 EST",]
   file <- file[file$date_time<"2007-09-18 23:0:00 EST",]
   file <- file[!is.na(file$`#YY`),]
  
 #file <- subset(file, MM=="09" & DD=="12" & DD=="13")
                                     
  assign(filenames[i], file)
}

# delete the "mm" column
for (i in 1:N){
  file <- get(filenames[i])
  assign(filenames[i],file[,c(1:4,6:19)])
}
