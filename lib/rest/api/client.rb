module Rest
  module Api

    class Client

      attr_accessor :host, :port, :protocol, :headers, :timeout

      def initialize(host, port, protocol = 'http', timeout = 5)
        @host = host
        @port = port
        @protocol = protocol
        @headers = {}
        @timeout = timeout
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
          # todo
          # log_request format_error(e, method, path, @headers, data)
          raise e
        end

        unless response.empty?
          response = ::Oj.load(response)
          response = to_hashie(response)
        end

        return format_response(200, 'ok', response)
      end

      def get(path)
        byebug
        RestClient::Request.execute(:method => :get, :url => path, :headers => @headers, :verify_ssl => false,
                                    :timeout => @timeout)
      end

      def post(path, data)
        RestClient::Request.execute(:method => :post, :url => path, :payload => data, :headers => @headers,
                                    :timeout => @timeout)
      end

      private

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

      def format_error(e, method, path, headers, data)
        error = "Error #{JSON.parse(e.http_body)['statusMessage']} while executing #{method} on #{path} with headers : #{headers} and data : #{data} | status = #{e.response.code}"
        return Response.new( 500, e.message, {}, error )
      end

      def format_response(status_code, status_message, data = nil)
        return Response.new( status_code, status_message, data )
      end

    end

  end
end

