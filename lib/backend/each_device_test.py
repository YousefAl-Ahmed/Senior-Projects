import pandas as pd
import numpy as np

def load_and_process_data(filepath):
    data = pd.read_csv(filepath, parse_dates=["Time"], index_col="Time")
    data /= 1000  # Convert milliwatts to watts
    return data

def predict_total_monthly_consumption_until_now(data):
    predictions = {}
    for device in data.columns:
        current_month_data = data[data.index.month == data.index[-1].month][device]
        daily_hourly_averages = current_month_data.resample('H').mean().resample('D').sum()
        total_current_month_consumption = daily_hourly_averages.sum()
        
        average_daily_consumption = total_current_month_consumption / daily_hourly_averages.shape[0]
        last_day_of_month = data.index[-1].to_period('M').to_timestamp(how='end')
        remaining_days = (last_day_of_month - data.index[-1]).days
        
        predicted_consumption_remaining_days = average_daily_consumption * remaining_days
        predicted_total_monthly_consumption = total_current_month_consumption + predicted_consumption_remaining_days
        
        predictions[device] = predicted_total_monthly_consumption / 1000
    return predictions

def get_percentage_difference(data):
    percentage_changes = {}
    for device in data.columns:
        two_recent_days = data[device].last('2D')
        hourly_means_recent_days = two_recent_days.resample('H').mean()
        daily_averages_recent_days = hourly_means_recent_days.resample('D').sum()

        if daily_averages_recent_days.size >= 2:
            yesterday_consumption = daily_averages_recent_days.iloc[-2]
            today_consumption = daily_averages_recent_days.iloc[-1]
            if yesterday_consumption == 0:
                percentage_changes[device] = -100
            else:
                percent_change = ((today_consumption - yesterday_consumption) / yesterday_consumption) * 100
                percentage_changes[device] = percent_change
        else:
            percentage_changes[device] = -100
    return percentage_changes

def get_total_consumption_today(data):
    total_consumptions = {}
    data_hourly = data.resample('H').mean()
    today_date = data_hourly.index[-1].date()
    current_hour = data_hourly.index[-1].hour
    
    for device in data.columns:
        today_consumption = data_hourly.loc[str(today_date), device]
        today_consumption_until_now = today_consumption[today_consumption.index.hour <= current_hour].sum()
        total_consumptions[device] = today_consumption_until_now
    return total_consumptions

def get_total_consumption_this_month(data):
    total_consumptions = {}
    for device in data.columns:
        last_month = data[data.index.month == data.index[-1].month][device]
        daily_hourly_averages = last_month.resample('H').mean().resample('D').sum()
        total_monthly_consumption = daily_hourly_averages.sum()
        total_consumptions[device] = total_monthly_consumption / 1000
    return total_consumptions

def get_average_consumption_per_hour(data):
    hourly_averages = {}
    last_date = data.index.max().normalize()
    
    for device in data.columns:
        last_day_hourly_data = data[last_date:last_date + pd.Timedelta(days=1)].resample('H')[device].mean()
        last_day_hourly_data.index = last_day_hourly_data.index.strftime('%H:%M')
        last_day_hourly_data = last_day_hourly_data.map("{:.1f}".format)
        hourly_averages[device] = last_day_hourly_data
    return hourly_averages



def get_daily_average_consumption_for_last_week(data):
    daily_averages = {}
    last_7_days = data.last('7D')
    
    for device in data.columns:
        hourly_means = last_7_days.resample('H')[device].mean()
        daily_averages_device = hourly_means.resample('D').sum()
        daily_averages[device] = daily_averages_device.map("{:.1f}".format)
        daily_averages[device].index = daily_averages[device].index.strftime('%Y-%m-%d')
    return daily_averages

def get_monthly_energy_consumption(data):
    monthly_percentages = {}
    for device in data.columns:
        monthly_data = data[device].resample('M').sum()
        monthly_percentage = (monthly_data / monthly_data.sum() * 100).round(2)
        monthly_percentage.index = monthly_percentage.index.strftime('%Y-%m')
        monthly_percentage = monthly_percentage.rename_axis("Month")
        monthly_percentages[device] = monthly_percentage
    return monthly_percentages

def aggregate_hourly(data):
    return data.resample('H').mean()

def calculate_normal_range(consumption_per_hour, device, hour):
    try:
        device_hourly_consumption = consumption_per_hour.loc[hour, device]
    except KeyError:
        return None, None
    q1 = device_hourly_consumption.quantile(0.25)
    q3 = device_hourly_consumption.quantile(0.75)
    iqr = q3 - q1
    iqr_std = iqr * 3
    lower_limit = q1 - iqr_std
    upper_limit = q3 + iqr_std
    return lower_limit, upper_limit

def calculate_outliers(data_hourly):
    outliers = {}
    consumption_per_hour = data_hourly.groupby([data_hourly.index.hour, data_hourly.index.date]).mean()
    
    for device in data_hourly.columns:
        device_outliers = []
        max_consumption = data_hourly[device].max()
        for hour in range(24):
            device_data_hour = data_hourly[(data_hourly.index.hour == hour)][device]
            lower_limit, upper_limit = calculate_normal_range(consumption_per_hour, device, hour)
            threshold = 0.5 * max_consumption
            
            for date, value in device_data_hour.items():
                if value < (lower_limit - threshold) or value > (upper_limit + threshold):
                    device_outliers.append({
                        "hour": hour,
                        "date": date.strftime('%Y-%m-%d'),
                        "value": value,
                        "lower_limit": lower_limit,
                        "upper_limit": upper_limit
                    })
        outliers[device] = device_outliers
    return outliers

# Testing the functions
file_path = 'new_Week_Electricity_Consumption_Data.csv'
data = load_and_process_data(file_path)

print("Predicted Total Monthly Consumption Until Now (in kWh):")
device1_predicted_total_monthly_consumption = predict_total_monthly_consumption_until_now(data)['Device 1'].round(2)
device2_predicted_total_monthly_consumption = predict_total_monthly_consumption_until_now(data)['Device 2'].round(2)
device3_predicted_total_monthly_consumption = predict_total_monthly_consumption_until_now(data)['Device 3'].round(2)
device4_predicted_total_monthly_consumption = predict_total_monthly_consumption_until_now(data)['Device 4'].round(2)
print(f"Device 1: {device1_predicted_total_monthly_consumption}")
print(f"Device 2: {device2_predicted_total_monthly_consumption}")
print(f"Device 3: {device3_predicted_total_monthly_consumption}")
print(f"Device 4: {device4_predicted_total_monthly_consumption}")


# device1_percentage_difference = get_percentage_difference(data)['Device 1'].round(2)
# device2_percentage_difference = get_percentage_difference(data)['Device 2'].round(2)
# device3_percentage_difference = get_percentage_difference(data)['Device 3'].round(2)
# device4_percentage_difference = get_percentage_difference(data)['Device 4'].round(2)
# print("Percentage Difference from Yesterday to Today:")
# print(f"Device 1: {device1_percentage_difference}%")
# print(f"Device 2: {device2_percentage_difference}%")
# print(f"Device 3: {device3_percentage_difference}%")
# print(f"Device 4: {device4_percentage_difference}%")

# device1_total_consumption_today = get_total_consumption_today(data)['Device 1'].round(2)
# device2_total_consumption_today = get_total_consumption_today(data)['Device 2'].round(2)
# device3_total_consumption_today = get_total_consumption_today(data)['Device 3'].round(2)
# device4_total_consumption_today = get_total_consumption_today(data)['Device 4'].round(2)
# print("\nTotal Consumption Today (in Wh):")
# print(f"Device 1: {device1_total_consumption_today}")
# print(f"Device 2: {device2_total_consumption_today}")
# print(f"Device 3: {device3_total_consumption_today}")
# print(f"Device 4: {device4_total_consumption_today}")

# print("\nTotal Consumption This Month (in kWh):")
# device1_total_consumption_this_month = get_total_consumption_this_month(data)['Device 1'].round(2)
# device2_total_consumption_this_month = get_total_consumption_this_month(data)['Device 2'].round(2)
# device3_total_consumption_this_month = get_total_consumption_this_month(data)['Device 3'].round(2)
# device4_total_consumption_this_month = get_total_consumption_this_month(data)['Device 4'].round(2)
# print(f"Device 1: {device1_total_consumption_this_month}")
# print(f"Device 2: {device2_total_consumption_this_month}")
# print(f"Device 3: {device3_total_consumption_this_month}")
# print(f"Device 4: {device4_total_consumption_this_month}")

# print("\nAverage Consumption Per Hour:")
# #average consumption per hour for device 1
# device1_average_consumption_per_hour = get_average_consumption_per_hour(data)['Device 1']
# print("Device 1:")
# print(device1_average_consumption_per_hour)

# #average consumption per hour for device 2
# device2_average_consumption_per_hour = get_average_consumption_per_hour(data)['Device 2']
# print("\nDevice 2:")
# print(device2_average_consumption_per_hour)

# #average consumption per hour for device 3
# device3_average_consumption_per_hour = get_average_consumption_per_hour(data)['Device 3']
# print("\nDevice 3:")
# print(device3_average_consumption_per_hour)

# #average consumption per hour for device 4
# device4_average_consumption_per_hour = get_average_consumption_per_hour(data)['Device 4']
# print("\nDevice 4:")
# print(device4_average_consumption_per_hour)

# print("\nDaily Average Consumption for Last Week:")
# #daily average consumption for last week for device 1
# device1_daily_average_consumption_for_last_week = get_daily_average_consumption_for_last_week(data)['Device 1']
# print("Device 1:")
# print(device1_daily_average_consumption_for_last_week)

# #get_average_consumption_per_hour for device 1
# device1_hourly_averages = get_average_consumption_per_hour(data)['Device 1']
# print("Device 1:")
# print(device1_hourly_averages)















# # print("Predicted Total Monthly Consumption Until Now (in kWh):")
# # print(predict_total_monthly_consumption_until_now(data))

# # print("\nPercentage Difference from Yesterday to Today:")
# # print(get_percentage_difference(data))

# # print("\nTotal Consumption Today (in kWh):")
# # print(get_total_consumption_today(data))

# # print("\nTotal Consumption This Month (in kWh):")
# # print(get_total_consumption_this_month(data))

# # print("\nAverage Consumption Per Hour:")
# # print(get_average_consumption_per_hour(data))

# # print("\nDaily Average Consumption for Last Week:")
# # print(get_daily_average_consumption_for_last_week(data))

# # print("\nMonthly Energy Consumption (Percentage):")
# # print(get_monthly_energy_consumption(data))

# # print("\nAggregated Hourly Data:")
# # print(aggregate_hourly(data).head())

# # print("\nOutliers:")
# # print(calculate_outliers(aggregate_hourly(data)))
