import pandas as pd
import numpy as np
from statsmodels.tsa.statespace.sarimax import SARIMAX

def load_and_process_data(filepath):
    data = pd.read_csv(filepath, parse_dates=["Time"], index_col="Time")
    data /= 1000  # Convert milliwatts to watts
    return data

def predict_total_monthly_consumption_until_now(data):
    data_hourly = data.resample('H').mean()# Convert from milliwatts to watts

    # Resample the hourly data to daily, then convert to kilowatts-hours for daily consumption
    data_daily = data_hourly.resample('D').sum() / 1000  # Convert watts to kilowatts
 
# SARIMA model configuration
    order = (1, 1, 1)
    seasonal_order = (1, 1, 1, 7)  # weekly seasonality
    
    # Fit the model
    def fit_sarima(data, order, seasonal_order):
        model = SARIMAX(data, order=order, seasonal_order=seasonal_order, enforce_stationarity=False, enforce_invertibility=False)
        model_fit = model.fit(disp=False)
        return model_fit
    
    # Predict the total consumption for the month
    def predict_monthly_consumption(data, model_fit):
        # Number of days to forecast (assuming one week data and aiming for a month)
        days_in_month = 30
        forecast = model_fit.get_forecast(steps=days_in_month)
        predicted_mean = forecast.predicted_mean
        total_monthly_consumption = predicted_mean.sum()  # Sum the daily predictions to get the monthly total
        #show only 3 decimal places
        

        return total_monthly_consumption
    
    # Model fitting and prediction for each device
    predictions = {}
    for device in data.columns:
        model_fit = fit_sarima(data_daily[device], order, seasonal_order)
        monthly_consumption = predict_monthly_consumption(data_daily[device], model_fit)
        predictions[device] = monthly_consumption
    
    prediction_of_all_devices = sum(predictions.values())
    return prediction_of_all_devices


def get_percentage_difference(data):
    
    two_recent_days = data.last('2D')

    # Resample by hour within each day and calculate mean
    hourly_means_recent_days = two_recent_days.resample('H').mean()

    # Calculate the daily average from the hourly averages for the two days
    daily_averages_recent_days = hourly_means_recent_days.resample('D').mean().sum(axis=1)

    # Calculate the percentage increase from yesterday to today
    if daily_averages_recent_days.size >= 2:
        yesterday_consumption = daily_averages_recent_days.iloc[-2]
        today_consumption = daily_averages_recent_days.iloc[-1]
        percent_change = ((today_consumption - yesterday_consumption) / yesterday_consumption) * 100
        return percent_change
    # result_message = f"You spent today {percent_change:.2f}% more than yesterday."
    else:
        result_message = "Not enough data to compare two days."

        return result_message,

        # result_message = "Not enough data to compare two days."


def get_total_consumption_today(data):
    data_hourly = data.resample('H').mean()
    today_date = data_hourly.index[-1].date()
 
# Get current hour from the last entry in the data (assuming it's today)
    current_hour = data_hourly.index[-1].hour
    
    # Filter the data for today and sum up to the current hour
    today_consumption = data_hourly.loc[str(today_date)]
    today_consumption_until_now = today_consumption[today_consumption.index.hour <= current_hour].sum()
    
    # Sum the total consumption across all devices
    total_consumption_all_devices = today_consumption_until_now.sum()
    #show only 3 decimal places
    return total_consumption_all_devices

def get_total_consumption_this_month(data):

    last_month = data[data.index.month == data.index[-1].month]

    # Resample by hour within each day and calculate mean, then sum up these means daily
    daily_hourly_averages = last_month.resample('H').mean().resample('D').sum()

    # Calculate the total consumption for the entire month by summing all daily totals
    total_monthly_consumption = daily_hourly_averages.sum(axis=1).sum()
    return total_monthly_consumption/1000
    
def get_average_consumption_per_hour(data):
    last_date = data.index.max().normalize()

    # Filter data for the last day and resample by hour to get mean values
    last_day_hourly_data = data[last_date:last_date + pd.Timedelta(days=1)].resample('H').mean()

    # Sum the consumption for all devices for each hour
    Total_last_day_hourly_total = last_day_hourly_data.sum(axis=1)
    formatted_output = Total_last_day_hourly_total.map("{:.1f}".format)
    formatted_output.index = formatted_output.index.strftime('%H:%M')

    # print("Total Hourly Energy Consumption for All Devices on the Last Day (in Watts):")
    return formatted_output


def get_daily_average_consumption_for_last_week(data):

    last_7_days = data.last('7D')
    # Resample by hour within each day and calculate mean
    hourly_means = last_7_days.resample('H').mean()
    # Calculate the daily average from the hourly averages
    daily_averages = hourly_means.resample('D').sum().sum(axis=1)
    # Formatting the results
    daily_averages = daily_averages.map("{:.1f}".format)

    daily_averages.index = daily_averages.index.strftime('%Y-%m-%d')
    # daily_averages = daily_averages.reset_index()
    # daily_averages.columns = ['Day', 'Average Consumption (W)']

    return daily_averages

def get_monthly_energy_consumption(data):
    monthly_data = data.resample('M').sum()

    # Calculate the total consumption for all devices for each month
    monthly_total = monthly_data.sum(axis=1)

    # Calculate the percentage contribution of each device to the total monthly consumption
    monthly_percentage = (monthly_data.div(monthly_total, axis=0) * 100).round(2)

    # Format the data to show month and percentages
    monthly_percentage.index = monthly_percentage.index.strftime('%Y-%m')
    monthly_percentage = monthly_percentage.rename_axis("Month")

    # Display the final dataframe
    return monthly_percentage
def aggregate_hourly(data):
    return data.resample('H').mean()

# def calculate_total_daily_energy(data_hourly):
#     return data_hourly.resample('D').sum()

# # Calculate Average Hourly Energy Consumption by device for each day
# def data_daily_hourly(data_hourly):
#     return data_hourly.resample('D').mean()

# #Calculate total daily energy consumption for all devices
# def calculate_total_daily_energy_all_devices(data_hourly):
#     return data_hourly.resample('D').sum().sum(axis=1)

# def calculate_energy_stats(data_hourly):
#     data_daily_hourly = data_hourly.resample('D').mean()
#     hourly_average = data_hourly.groupby(data_hourly.index.hour).mean()
#     return data_daily_hourly, hourly_average


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
