# READ the data, tidy column names
data <- read.csv("unemployment_rate.csv")
data <- data[-nrow(data), ]
head(data)
str(data)

colnames(data) <- c("date", "unemployment")

# format date and ts object, set n = sample size
data$date <- as.Date(data$date)

unemp_ts <- ts(data$unemployment,
               start = c(1976, 1),
               frequency = 12)

n <- length(unemp_ts)

# train set: 1976.01 to 2015.12 (80%)
train_ts <- window(unemp_ts, end = c(2015, 12))

# holdout set: 2016.01 to 2025.12 (20%)
holdout_ts <- window(unemp_ts, start = c(2016, 1))

### PLOTS
# train set TS plot
train_ts_plot <- plot(train_ts,
       main = "Training Set: Canada Monthly Unemployment Rate (1976–2015)",
       ylab = "Unemployment Rate", xlab = "Year")

# ACF
acf_plot <- acf(train_ts, main = "ACF of Training Series")

# PACF
pacf_plot <- pacf(train_ts, main = "PACF of Training Series")


### ARIMA FITTING
library(forecast)

## 1. auto.arima fit
# no differencing applied (stationary = TRUE)
fit_stat <- auto.arima(train_ts, seasonal = TRUE, stationary = TRUE)
fc_stat <- forecast(fit_stat, h = length(holdout_ts))

# differencing applied (stationary = FALSE) ;default
fit_nonstat <- auto.arima(train_ts, seasonal = TRUE, stationary = FALSE)
fc_nonstat <- forecast(fit_nonstat, h = length(holdout_ts))

summary(fit_stat)
summary(fit_nonstat)

# RMSE values for holdout set
rmse_stat <- sqrt(mean((holdout_ts - fc_stat$mean)^2))
rmse_nonstat <- sqrt(mean((holdout_ts - fc_nonstat$mean)^2))

rmse_stat
rmse_nonstat

# residuals plots
par(mfrow = c(1,2))
acf(residuals(fit_nonstat), main = "Residual ACF of auto.arima model")
pacf(residuals(fit_nonstat), main = "Residual PACF of auto.arima model")
plot(residuals(fit_nonstat))

# BASELINE MODEL: ARIMA(1,1,3)(1,0,2)[12] 

## 2. arima fit (perturbed values from auto.arima)