json.points @track_data.points
json.wind_cancellation @track_data.weather_data.any?
json.zerowind_points @track_data.zerowind_points
json.weather_data @track_data.weather_data