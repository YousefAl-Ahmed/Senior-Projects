import pandas as pd
import numpy as np

def led_usage_pattern(led_base, led_peak, size, start_time):
    led_usage = np.random.uniform(-1, 1, size=size)  # Most times off
    for i in range(size):
        hour = (start_time + pd.Timedelta(seconds=i)).hour
        if 18 <= hour or hour < 6:
            led_usage[i] = np.random.uniform(led_base, led_peak)
        elif np.random.random() < 0.05:  # Rare daytime usage
            led_usage[i] = np.random.uniform(led_base, led_peak)
    return led_usage

# Constants
n_seconds_week = 7 * 24 * 60 * 60  # 7 days in seconds

# Start time for the data generation
start_time = pd.Timestamp('2024-05-07')

# Time range
new_time_range = pd.date_range(start=start_time, periods=n_seconds_week, freq='S')

# Motor (AC) behavior modification: ON from 22:00 to 06:00 and from 16:00 to 18:00
motor_usage_week = np.random.uniform(-1, 1, size=n_seconds_week)  # Start all off
for i in range(n_seconds_week):
    hour = new_time_range[i].hour
    if 22 <= hour or hour < 6 or (16 <= hour < 18):
        motor_usage_week[i] = np.random.uniform(3000, 5000)  # AC is on

# Generate LED data with daily consumption variations
led1_week = led_usage_pattern(300, 400, n_seconds_week, start_time)  # High average consumption
led2_week = led_usage_pattern(200, 250, n_seconds_week, start_time)  # Low average consumption
led3_week = led_usage_pattern(250, 350, n_seconds_week, start_time)  # Normal average consumption

# Introduce daily variations for more realistic consumption
daily_variation = np.random.uniform(0.8, 1.2, size=7)

for day in range(7):
    start_idx = day * 24 * 60 * 60
    end_idx = (day + 1) * 24 * 60 * 60
    motor_usage_week[start_idx:end_idx] *= daily_variation[day]
    led1_week[start_idx:end_idx] *= daily_variation[day]
    led2_week[start_idx:end_idx] *= daily_variation[day]
    led3_week[start_idx:end_idx] *= daily_variation[day]

# Create DataFrame
df_week = pd.DataFrame({
    'Time': new_time_range,
    'Device 1': motor_usage_week,
    'Device 2': led1_week,
    'Device 3': led2_week,
    'Device 4': led3_week
})

# Set Time as index
df_week.set_index('Time', inplace=True)

# Save to CSV
df_week.to_csv('new_Week_Electricity_Consumption_Data.csv')

print("Data has been saved to 'new_Week_Electricity_Consumption_Data.csv'.")
