import pandas as pd
import numpy as np
from statsmodels.tsa.statespace.sarimax import SARIMAX

def load_and_process_data(filepath):
    data = pd.read_csv(filepath, parse_dates=["Time"], index_col="Time")
    data /= 1000  # Convert milliwatts to watts
    return data

def aggregate_hourly(data):
    return data.resample('H').mean()

def calculate_total_daily_energy(data_hourly):
    return data_hourly.resample('D').sum()

# Calculate Average Hourly Energy Consumption by device for each day
def data_daily_hourly(data_hourly):
    return data_hourly.resample('D').mean()

#Calculate total daily energy consumption for all devices
def calculate_total_daily_energy_all_devices(data_hourly):
    return data_hourly.resample('D').sum().sum(axis=1)

def calculate_energy_stats(data_hourly):
    data_daily_hourly = data_hourly.resample('D').mean()
    hourly_average = data_hourly.groupby(data_hourly.index.hour).mean()
    return data_daily_hourly, hourly_average


def calculate_normal_range(consumption_per_hour, device, hour):
    device_hourly_consumption = consumption_per_hour.loc[hour, device]
    q1 = device_hourly_consumption.quantile(0.25)
    q3 = device_hourly_consumption.quantile(0.75)
    iqr = q3 - q1
    iqr_std = iqr * 3
    lower_limit = q1 - iqr_std
    upper_limit = q3 + iqr_std
    return lower_limit, upper_limit

def calculate_outliers(data_hourly):
    outliers = []
    consumption_per_hour = data_hourly.groupby([data_hourly.index.hour, data_hourly.index.date]).mean()
    for device in data_hourly.columns:
        max_consumption = data_hourly[device].max()
        for hour in range(24):
            device_data_hour = data_hourly[(data_hourly.index.hour == hour)][device]
            lower_limit, upper_limit = calculate_normal_range(consumption_per_hour, device, hour)
            threshold = 0.5 * max_consumption
            for date, value in device_data_hour.items():
                if value < (lower_limit - threshold) or value > (upper_limit + threshold):
                    outliers.append({
                        "device": device,
                        "hour": hour,
                        "date": date.strftime('%Y-%m-%d'),
                        "value": value,
                        "lower_limit": lower_limit,
                        "upper_limit": upper_limit
                    })
    return outliers
# def forecast_energy(data, device, hour_of_day):
#     data_device_hour = data[[device]].iloc[hour_of_day::24]
#     return predict_sarima(data_device_hour)
