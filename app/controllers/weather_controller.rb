class WeatherController < ApplicationController
  def index
  end

  def list_users
    render json: { users: [{ name: 'Michael' }, { name: 'Dwight' }] }
  end

  def city

  end

end
