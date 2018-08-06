class ForecastService

  def initialize
    #todo - move @apikey to secrets
    #todo - move @host to config
    #
    @apikey = 'Sxh5xGtrvCnPaGtxR5gThhI4BqB5qr2d'
    @host = 'dataservice.accuweather.com'
    @five_days_forecast_path = '/forecasts/v1/daily/5day/'

    #todo - vary metric by IP
    @metric = true
  end

  def get_five_days_forecast_by_lk(location_key)
    client = Rest::Api::Client.new(@host, 80)
    path_key = "#{location_key}"
    client.request('get', @five_days_forecast_path + path_key,
                   { request_params: { apikey: @apikey, metric: @metric } })
  end

end
