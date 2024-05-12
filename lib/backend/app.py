from flask import Flask, jsonify, request
import energy_analysis as ea

app = Flask(__name__)




@app.route('/load_data', methods=['GET','POST'])
def load_data():
    try:
        filepath = request.json['filepath']

        data = ea.load_and_process_data(filepath)
        predict_total_monthly_consumption_until_now = ea.predict_total_monthly_consumption_until_now(data)
        data_hourly = ea.aggregate_hourly(data)
        percentage_difference = ea.get_percentage_difference(data_hourly)
        total_consumption_today = ea.get_total_consumption_today(data_hourly)
        total_consumption_this_month = ea.get_total_consumption_this_month(data_hourly)
        average_consumption_per_hour = ea.get_average_consumption_per_hour(data_hourly)
        daily_average_consumption_for_last_week = ea.get_daily_average_consumption_for_last_week(data_hourly)
        monthly_energy_consumption = ea.get_monthly_energy_consumption(data_hourly)
        outliers = ea.calculate_outliers(data_hourly)
        
        return jsonify({
            'predict_total_monthly_consumption_until_now': predict_total_monthly_consumption_until_now,
            'percentage_difference': percentage_difference,
            'total_consumption_today': total_consumption_today,
            'total_consumption_this_month': total_consumption_this_month,
            'average_consumption_per_hour': average_consumption_per_hour,
            'daily_average_consumption_for_last_week': daily_average_consumption_for_last_week,
            'monthly_energy_consumption': monthly_energy_consumption,
            'outliers': outliers  # This should be JSON serializable
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/forecast', methods=['POST'])
def forecast():
    try:
        filepath = request.json['filepath']
        device = request.json['device']
        hour_of_day = request.json['hour_of_day']
        data = ea.load_and_process_data(filepath)
        data_hourly = ea.aggregate_hourly(data)
        forecast = ea.forecast_energy(data_hourly, device, hour_of_day)
        
        return jsonify({
            'forecast': forecast.to_json()  # This needs to handle serialization properly
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)
