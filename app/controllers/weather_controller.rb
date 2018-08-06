class WeatherController < ApplicationController
  def index
  end

  def index
    # get location key (LK) by IP
    ls = LocationService.new
    location_key = ls.get_location_key_by_ip('192.168.1.1')

    # get weather forecast for 3 days for LK
    fs = ForecastService.new
    forecast = fs.get_five_days_forecast_by_lk(location_key)


    # todo render forecast
    render json: { forecast: forecast }
  end

end
