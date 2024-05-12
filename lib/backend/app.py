from flask import Flask, jsonify, request
import energy_analysis as ea

app = Flask(__name__)

@app.route('/load_data', methods=['POST'])
def load_data():
    try:
        filepath = request.json['filepath']
        data = ea.load_and_process_data(filepath)
        data_hourly = ea.aggregate_hourly(data)
        total_daily_energy = ea.calculate_total_daily_energy(data_hourly)
        total_daily_energy_all_devices = ea.calculate_total_daily_energy_all_devices(data_hourly)
        data_daily_hourly, hourly_average = ea.calculate_energy_stats(data_hourly)
        outliers = ea.calculate_outliers(data_hourly)
        
        return jsonify({
            'total_daily_energy': total_daily_energy.to_json(),
            'total_daily_energy_all_devices': total_daily_energy_all_devices.to_json(),
            'data_daily_hourly': data_daily_hourly.to_json(),
            'hourly_average': hourly_average.to_json(),
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
