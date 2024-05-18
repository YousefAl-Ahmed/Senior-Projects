import time
from flask import Flask, jsonify, request, make_response, Response
import energy_analysis as ea
from flask_cors import CORS

app = Flask(__name__)
CORS(app)



path = "C:/Users/Jawad/Documents/GitHub/Senior-Projects-1/lib/backend/new_Week_Electricity_Consumption_Data.csv"
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
        
@app.route('/device1', methods=['OPTIONS','POST','GET'])
def device1():
    if request.method == 'OPTIONS':
        response = make_response()
        response.headers.add("Access-Control-Allow-Origin", "*")
        response.headers.add("Access-Control-Allow-Headers", "*")
        response.headers.add("Access-Control-Allow-Methods", "*")
        return response
    
    elif request.method == 'POST':
        if not request.json or 'filepath' not in request.json:
            return jsonify({'error': 'Bad Request: No filepath provided'}), 400

        filepath = path
    
        try:
            data = ea.load_and_process_data(filepath)
            data_hourly = ea.aggregate_hourly(data)
            predict_total_monthly_consumption_until_now_1 = ea.get_predict_total_monthly_consumption_until_now_device1(data_hourly) # Assuming this returns a DataFrame
            percentage_difference_1 = ea.get_percentage_difference_device1(data_hourly)  # Adjust based on actual return type
            total_consumption_today_1 = ea.get_total_consumption_today_device1(data_hourly)  # Adjust based on actual return type
            total_consumption_this_month_1 = ea.get_total_consumption_this_month_device1(data_hourly)  # Adjust based on actual return type
            average_consumption_per_hour_1 = ea.get_hourly_average_device1(data_hourly).to_json(orient = 'columns')  # Adjust based on actual return type     
            daily_average_consumption_for_last_week_1 = ea.get_daily_average_consumption_for_last_week_device1(data_hourly).to_json(orient = 'columns')  # Adjust based on actual return type

            # Serialize all data points properly
            result = {
                'predict_total_monthly_consumption_until_now_1': predict_total_monthly_consumption_until_now_1,
                'percentage_difference_1': percentage_difference_1,
                'total_consumption_today_1': total_consumption_today_1,
                'total_consumption_this_month_1': total_consumption_this_month_1,
                'average_consumption_per_hour_1': average_consumption_per_hour_1,
                'daily_average_consumption_for_last_week_1': daily_average_consumption_for_last_week_1,
              
            }
            return jsonify(result)
        except Exception as e:
            app.logger.error(f"Failed to process data: {str(e)}", exc_info=True)

            return jsonify({'error': str(e)}), 500

@app.route('/device2', methods=['OPTIONS','POST'])
def device2():
    if request.method == 'OPTIONS':
        response = make_response()
        response.headers.add("Access-Control-Allow-Origin", "*")
        response.headers.add("Access-Control-Allow-Headers", "*")
        response.headers.add("Access-Control-Allow-Methods", "*")
        return response
    
    elif request.method == 'POST':
        if not request.json or 'filepath' not in request.json:
            return jsonify({'error': 'Bad Request: No filepath provided'}), 400

        filepath = path
    
        try:
            data = ea.load_and_process_data(filepath)
            data_hourly = ea.aggregate_hourly(data)
            predict_total_monthly_consumption_until_now_2 = ea.get_predict_total_monthly_consumption_until_now_device2(data_hourly) # Assuming this returns a DataFrame
            percentage_difference_2 = ea.get_percentage_difference_device2(data_hourly)  # Adjust based on actual return type
            total_consumption_today_2 = ea.get_total_consumption_today_device2(data_hourly)  # Adjust based on actual return type
            total_consumption_this_month_2 = ea.get_total_consumption_this_month_device2(data_hourly)  # Adjust based on actual return type
            average_consumption_per_hour_2 = ea.get_hourly_average_device2(data_hourly).to_json(orient = 'columns')  # Adjust based on actual return type     
            daily_average_consumption_for_last_week_2 = ea.get_daily_average_consumption_for_last_week_device2(data_hourly).to_json(orient = 'columns')  # Adjust based on actual return type

            # Serialize all data points properly
            result = {
                'predict_total_monthly_consumption_until_now_2': predict_total_monthly_consumption_until_now_2,
                'percentage_difference_2': percentage_difference_2,
                'total_consumption_today_2': total_consumption_today_2,
                'total_consumption_this_month_2': total_consumption_this_month_2,
                'average_consumption_per_hour_2': average_consumption_per_hour_2,
                'daily_average_consumption_for_last_week_2': daily_average_consumption_for_last_week_2,
              
            }
            return jsonify(result)
        except Exception as e:
            app.logger.error(f"Failed to process data: {str(e)}", exc_info=True)

            return jsonify({'error': str(e)}), 500
        
@app.route('/device3', methods=['OPTIONS','POST'])
def device3():
    if request.method == 'OPTIONS':
        response = make_response()
        response.headers.add("Access-Control-Allow-Origin", "*")
        response.headers.add("Access-Control-Allow-Headers", "*")
        response.headers.add("Access-Control-Allow-Methods", "*")
        return response
    
    elif request.method == 'POST':
        if not request.json or 'filepath' not in request.json:
            return jsonify({'error': 'Bad Request: No filepath provided'}), 400

        filepath = path
    
        try:
            data = ea.load_and_process_data(filepath)
            data_hourly = ea.aggregate_hourly(data)
            predict_total_monthly_consumption_until_now_3 = ea.get_predict_total_monthly_consumption_until_now_device3(data_hourly) # Assuming this returns a DataFrame
            percentage_difference_3 = ea.get_percentage_difference_device3(data_hourly)  # Adjust based on actual return type
            total_consumption_today_3 = ea.get_total_consumption_today_device3(data_hourly)  # Adjust based on actual return type
            total_consumption_this_month_3 = ea.get_total_consumption_this_month_device3(data_hourly)  # Adjust based on actual return type
            average_consumption_per_hour_3 = ea.get_hourly_average_device3(data_hourly).to_json(orient = 'columns')  # Adjust based on actual return type     
            daily_average_consumption_for_last_week_3 = ea.get_daily_average_consumption_for_last_week_device3(data_hourly).to_json(orient = 'columns')  # Adjust based on actual return type

            # Serialize all data points properly
            result = {
                'predict_total_monthly_consumption_until_now_3': predict_total_monthly_consumption_until_now_3,
                'percentage_difference_3': percentage_difference_3,
                'total_consumption_today_3': total_consumption_today_3,
                'total_consumption_this_month_3': total_consumption_this_month_3,
                'average_consumption_per_hour_3': average_consumption_per_hour_3,
                'daily_average_consumption_for_last_week_3': daily_average_consumption_for_last_week_3,
              
            }
            return jsonify(result)
        except Exception as e:
            app.logger.error(f"Failed to process data: {str(e)}", exc_info=True)

            return jsonify({'error': str(e )}), 500
        
@app.route('/device4', methods=['OPTIONS','POST'])
def device4():
    if request.method == 'OPTIONS':
        response = make_response()
        response.headers.add("Access-Control-Allow-Origin", "*")
        response.headers.add("Access-Control-Allow-Headers", "*")
        response.headers.add("Access-Control-Allow-Methods", "*")
        return response
    
    elif request.method == 'POST':
        
    
        try:
            filepath = path
            data = ea.load_and_process_data(filepath)
            data_hourly = ea.aggregate_hourly(data)
            predict_total_monthly_consumption_until_now_4 = ea.get_predict_total_monthly_consumption_until_now_device4(data) # Assuming this returns a DataFrame
            percentage_difference_4 = ea.get_percentage_difference_device4(data_hourly)  # Adjust based on actual return type
            total_consumption_today_4 = ea.get_total_consumption_today_device4(data_hourly)  # Adjust based on actual return type
            total_consumption_this_month_4 = ea.get_total_consumption_this_month_device4(data_hourly)  # Adjust based on actual return type
            average_consumption_per_hour_4 = ea.get_hourly_average_device4(data_hourly).to_json(orient = 'columns')  # Adjust based on actual return type     
            daily_average_consumption_for_last_week_4 = ea.get_daily_average_consumption_for_last_week_device4(data_hourly).to_json(orient = 'columns')  # Adjust based on actual return type

            # Serialize all data points properly
            result = {
                'predict_total_monthly_consumption_until_now_4': predict_total_monthly_consumption_until_now_4,
                'percentage_difference_4': percentage_difference_4,
                'total_consumption_today_4': total_consumption_today_4,
                'total_consumption_this_month_4': total_consumption_this_month_4,
                'average_consumption_per_hour_4': average_consumption_per_hour_4,
                'daily_average_consumption_for_last_week_4': daily_average_consumption_for_last_week_4,
              
            }
            return jsonify(result)
        except Exception as e:
            app.logger.error(f"Failed to process data: {str(e)}", exc_info=True)

            return jsonify({'error': str(e )}), 500

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


import requests

def send_command_to_esp(device_id, command):
    # This is an example URL; adjust it as needed for your actual ESP device setup.
    esp_url = f'http://esp-device-address/command'
    response = requests.post(esp_url, json={'device_id': device_id, 'command': command})
    return response.status_code


@app.route('/turn_off_device', methods=['POST'])
def turn_off_device():
    try:
        device_id = request.json.get('deviceId')
        if not device_id:
            return jsonify({'error': 'Missing device ID'}), 400
        
        # Sending the 'off' command to the device
        status_code = send_command_to_esp(device_id, 'off')
        if status_code == 200:
            return jsonify({'message': 'Device turned off successfully'}), 200
        else:
            return jsonify({'error': 'Failed to send command to device'}), status_code
    except Exception as e:
        app.logger.error(f"Error turning off device: {str(e)}", exc_info=True)
        return jsonify({'error': str(e)}), 500



if __name__ == '__main__':
    app.run(debug=True, port=5000)
