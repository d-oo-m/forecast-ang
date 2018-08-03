class WeatherController < ApplicationController
  def index
  end

  def location
    # todo - get city
    service = LocationService.new
    location = service.get_location_key_by_ip('192.168.1.1')

    render json: { location: location }
  end

end
