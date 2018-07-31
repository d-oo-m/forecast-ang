class WeatherController < ApplicationController
  def index
  end

  def list_users
    render json: { users: [{ name: 'Michael' }, { name: 'Dwight' }] }
  end

  def city
    # todo - get city
    service = LocationService.new
    location = service.get_location_by_ip('192.168.1.1')

    byebug

    render json: { location: location }
  end

end
