class LocationService

  def initialize
    @apikey = 'Sxh5xGtrvCnPaGtxR5gThhI4BqB5qr2d'
    @host = 'dataservice.accuweather.com'
    @ip_address_path = '/locations/v1/cities/ipaddress'
  end

  def get_location_key_by_ip(ip)
    # todo  request.remote_ip
    ip = '193.84.22.30'
    client = Rest::Api::Client.new(@host, 80)
    response = client.request('get', @ip_address_path, {request_params: { apikey: @apikey, q: ip } })
    response.data["Key"]
  end

  def get_location_by_geo

  end

  def get_city_key_by_name
    # 324561 for Lviv
  end

  def get_matched_cities
    #autocomplete
  end

end
