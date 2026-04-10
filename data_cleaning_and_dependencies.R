suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(forecast))
suppressPackageStartupMessages(library(corrplot))
suppressPackageStartupMessages(library(knitr))

# Reading in dataset
unempl <- read.csv("data/unemployment.csv", header=TRUE)
LF_total <- read.csv("data/LFPR_total.csv", header=TRUE)
WAP_total <- read.csv("data/WP_total.csv", header=TRUE)
int_rate <- read.csv("data/interest_rate.csv", header=TRUE)

obs_date_colname = "date"
UR_colname = "unemployment"
LFP_colname = "labor_part"
WAP_colname = "work_pop"
IR_colname = "int_rates"

# Renaming column names
colnames(unempl) <- c(obs_date_colname, UR_colname)
colnames(LF_total) <- c(obs_date_colname, LFP_colname)
colnames(WAP_total) <- c(obs_date_colname, WAP_colname)
colnames(int_rate) <- c(obs_date_colname, IR_colname)

# Combine dataframes into one
data <- merge(unempl, LF_total, id=obs_date_colname) %>% 
  merge(WAP_total, id=obs_date_colname) %>%
  merge(int_rate, id=obs_date_colname)

# Create time Series Objects
start_date <- c(1976, 1)
train_end_date <- c(2015, 12)
holdout_start_date <- c(2016, 1)

unempl_ts <- ts(data[, UR_colname], start=start_date, frequency=12)
train_ts <- window(unempl_ts, end=c(2015, 12))
holdout_ts <- window(unempl_ts, start=c(2016, 1))

n_train = length(train_ts)
n = nrow(data)

# Creating dataframe object Object
train_df <- data[1:n_train, ]
holdout_df <- data[(n_train+1):n, ]

train_unemp <- train_df$unemployment_rate
holdout_unemp <- holdout_df$unemployment_rate




