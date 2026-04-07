library(forecast)
library(dplyr)

unempl <- read.csv("data/unemployment.csv", header=TRUE)
colnames(unempl) <- c("observation_date", "unemployment_rate")

unempl_ts <- ts(unempl$unemployment_rate, start=c(1976, 1), frequency=12)
train_ts <- window(unempl_ts, end=c(2015, 12))
test_ts <- window(unempl_ts, start=c(2016, 1))

# 
arima_fit <-  auto.arima(train_ts, stationary=FALSE, seasonal=TRUE)

holdout_pred <- predict(arima_fit, n.ahead=length(test_ts))

# ARMAX
lag_1_unmpl <- diff(unempl, diff=1)


