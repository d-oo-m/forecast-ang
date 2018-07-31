class LocationService

  def initialize
    @api_key = 'Sxh5xGtrvCnPaGtxR5gThhI4BqB5qr2d'
    @host = 'http://dataservice.accuweather.com'
    @ip_address_path = 'locations/v1/cities/ipaddress'
  end

  def get_location_by_ip(ip)
    # todo  request.remote_ip
    ip = '193.84.22.30'

    byebug

    client = Rest::Api::Client.new(@host, 80)
    response = client.request('get', @ip_address_path, {api_key: @api_key, q: ip})

  end

  def get_location_by_geo

  end

  def get_city_key_by_name
    # 324561 for Lviv
  end

  def get_matched_cities
    #autocomplete
  end



  def request(method, path, options = {})
    response = data = nil
    path = url(method, path, options)
    data = payload(options) if method != 'get'

    begin
      case method
      when 'get'
        response = self.get(path)
      when 'post'
        response = self.post(path, data)
      end
    rescue Exception => e
      log_request format_error(e, method, path, @headers, data)
      raise e
    end

    unless response.empty?
      response = ::Oj.load(response)
      response = to_hashie(response)
    end

    return format_response(200, 'ok', response)
  end

  private

  def get(path)
    RestClient::Request.execute(:method => :get, :url => path, :headers => @headers, :verify_ssl => false,
                                :timeout => @timeout)
  end

  def post(path, data)
    RestClient::Request.execute(:method => :post, :url => path, :payload => data, :headers => @headers,
                                :timeout => @timeout)
  end

  def url(method, path, options = {})
    query_string = build_query(options[:request_params]) if method.eql? 'get'
    if @protocol == 'http'
      uri = URI::HTTP.build(:host => @host, :port => @port, :path => URI::encode(path), :query => query_string)
    else
      uri = URI::HTTPS.build(:host => @host, :port => @port, :path => URI::encode(path), :query => query_string)
    end
    uri.to_s
  end

  def build_query(options)
    return nil if options.nil? or options.empty?
    options = options.collect do |name, value|
      if value.is_a? Array
        value.collect { |v| "#{name}=#{v.class.to_s != 'Fixnum' ? escape_string(v.to_s) : v}" }.join('&')
      else
        "#{name}=#{!value.nil? ? (value.class.to_s != 'Fixnum' ? escape_string(value.to_s) : value) : ''}"
      end
    end.join('&')
    options
  end

  def escape_string(str)
    URI.escape(str, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

  def payload(options)
    return {} if !options.has_key? :request_params
    if options.has_key?(:url_encode) && options[:url_encode]
      return options[:request_params]
    else
      return ::Oj.dump(options[:request_params])
    end
  end

  def to_hashie json
    if json.is_a? Array
      json.collect! { |x| x.is_a?(Hash) ? Hashie::Mash.new(x) : x }
    else
      Hashie::Mash.new(json)
    end
  end





end