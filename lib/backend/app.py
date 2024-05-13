import time
from flask import Flask, jsonify, request, make_response, Response
import energy_analysis as ea
from flask_cors import CORS

app = Flask(__name__)
CORS(app)




@app.route('/load_data', methods=['OPTIONS','POST'])
def load_data():
    if request.method == 'OPTIONS':
        response = make_response()
        response.headers.add("Access-Control-Allow-Origin", "*")
        response.headers.add("Access-Control-Allow-Headers", "*")
        response.headers.add("Access-Control-Allow-Methods", "*")
        return response
    
    elif request.method == 'POST':
        if not request.json or 'filepath' not in request.json:
            return jsonify({'error': 'Bad Request: No filepath provided'}), 400

        filepath = request.json['filepath']
    
        try:
            filepath = request.json['filepath']
            data = ea.load_and_process_data(filepath)
            data_hourly = ea.aggregate_hourly(data)
            # Calculate all required metrics
            predict_total_monthly_consumption_until_now = ea.predict_total_monthly_consumption_until_now(data_hourly) # Assuming this returns a DataFrame
            percentage_difference = ea.get_percentage_difference(data_hourly)  # Adjust based on actual return type
            total_consumption_today = ea.get_total_consumption_today(data_hourly)  # Adjust based on actual return type
            total_consumption_this_month = ea.get_total_consumption_this_month(data_hourly)  # Adjust based on actual return type
            average_consumption_per_hour = ea.get_average_consumption_per_hour(data_hourly).to_json(orient = 'columns')  # Adjust based on actual return type
            daily_average_consumption_for_last_week = ea.get_daily_average_consumption_for_last_week(data_hourly).to_json(orient = 'columns')  # Adjust based on actual return type
            monthly_energy_consumption = ea.get_monthly_energy_consumption(data_hourly).to_json(orient = 'split')  # Adjust based on actual return type
            outliers = ea.calculate_outliers(data_hourly)  # Adjust based on actual return type
            
            # Serialize all data points properly
            result = {
                'predict_total_monthly_consumption_until_now': predict_total_monthly_consumption_until_now,
                'percentage_difference': percentage_difference,
                'total_consumption_today': total_consumption_today,
                'total_consumption_this_month': total_consumption_this_month,
                'average_consumption_per_hour': average_consumption_per_hour,
                'daily_average_consumption_for_last_week': daily_average_consumption_for_last_week,
                'monthly_energy_consumption': monthly_energy_consumption,
                'outliers': outliers,  # Make sure this is also properly serialized
                
            }
            return jsonify(result)
        except Exception as e:
            app.logger.error(f"Failed to process data: {str(e)}", exc_info=True)

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
    


def stream_energy_data(filepath):
    # Simulating a continuous data stream
    while True:
        data = ea.load_and_process_data(filepath)
        data_hourly = ea.aggregate_hourly(data)
        result = jsonify.dumps({
            'total_consumption_today': ea.get_total_consumption_today(data_hourly)
        })
        yield f"data:{result}\n\n"
        time.sleep(1)  # Stream update every second

@app.route('/stream_data', methods=['GET'])
def stream_data():
    filepath = request.args.get('filepath')
    return Response(stream_energy_data(filepath), mimetype='text/event-stream')


if __name__ == '__main__':
    app.run(debug=True, port=5000)
