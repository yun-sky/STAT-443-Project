suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(forecast))
suppressPackageStartupMessages(library(corrplot))

# Reading in dataset
unempl <- read.csv("data/unemployment.csv", header=TRUE)
LF_total <- read.csv("data/LFPR_total.csv", header=TRUE)
WAP_total <- read.csv("data/WP_total.csv", header=TRUE)
int_rate <- read.csv("data/interest_rate.csv", header=TRUE)

UR_colname = "unemployment_rate"
LFP_colname = "labor_force_total"
WAP_colname = "working_pop_total"
IR_colname = "interest_rate"

# Renaming column names
colnames(unempl) <- c("observation_date", "unemployment_rate")
colnames(LF_total) <- c("observation_date", "labor_force_total")
colnames(WP_total) <- c("observation_date", "working_pop_total")
colnames(int_rate) <- c("observation_date", "interest_rate")

# Combine dataframes into one
data <- merge(unempl, LF_total, id="observation_date") %>% 
  merge(WP_total, id="observation_date") %>%
  merge(int_rate, id="observation_date")

# Create time Series Objects
start_date <- c(1976, 1)
train_end_date <- c(2015, 12)
holdout_start_date <- c(2016, 1)

unempl_ts <- ts(data$unemployment, start=start_date, frequency=12)
train_ts <- window(unempl_ts, end=c(2015, 12))
holdout_ts <- window(unempl_ts, start=c(2016, 1))

n_train = length(train_ts)
n = nrow(data)

# Creating datafrmae object Object
train_df <- data[1:n_train, ]
holdout_df <- data[n_train+1:n, ]





