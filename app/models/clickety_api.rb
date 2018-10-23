require 'uri'
require 'net/http'
require 'json'

class ClicketyApi < ActiveRecord::Base
  def self.track_user(*args)
    errors = ''
    response = {}
    if args[0].nil? || !args[0].nil? && !args[0].is_a?(Hash)
      errors += 'Error - no arguments were received.'
    elsif !args[0].nil? && args[0].key?(:user_agent) && (args[0][:user_agent].nil? || !args[0][:user_agent].nil? && args[0][:user_agent].downcase.include?('bot/'))
      errors += 'Error - this user is a bot.'
    else
      data = make_object(args)
      response, errors = send_request('track', data)
    end

    { response: response, errors: errors }
  end

  def self.track_referer(*args)
    errors = ''
    response = {}
    if args[0].nil? || !args[0].nil? && !args[0].is_a?(Hash)
      errors += 'Error - no arguments were received.'
    elsif !args[0].nil? && args[0].key?(:referer) && args[0][:referer].key?(:user_agent) && args[0][:user_agent].present? && args[0][:user_agent].downcase.include?('bot/')
      errors += 'Error - this user is a bot.'
    else
      data = make_object(args)
      response, errors = send_request('referer', data)
    end

    { response: response, errors: errors }
  end

  def self.update_user(*args)
    errors = ''
    response = {}
    if args[0].nil? || !args[0].nil? && !args[0].is_a?(Hash)
      errors += 'Error - no arguments were received.'
    else
      data = make_object(args)
      response, errors = send_request('update', data)
    end
    { response: response, errors: errors }
  end

  private_class_method def self.make_object(args)
    p = {}
    p[:user_data] = {}
    user_data_keys = %i[campaign_id ad_group_name ad_name keywords expire_days]

    unless args.nil? || !args.is_a?(Array)
      args.first.each do |k, v|
        p[:user_data][k] = v if user_data_keys.include?(k)
        p[k] = v unless user_data_keys.include?(k)
      end
    end

    p
  end

  private_class_method def self.send_request(type, request_params)
    errors = ''
    response = {}
    api_key = ENV['CLICKETY_API_KEY']
    
    if api_key.nil?
      errors  += 'Error - API key not found. Please set it in the environment as CLICKETY_API_KEY.'
    else
      uri = URI('https://api.clickety.com/v1/track')

      if type == 'referer'
        uri = URI('https://api.clickety.com/v1/referer')
      end
      content = { 'Content-Type' => 'application/json' }

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri, content) if (type == 'track' || type == 'referer')
      request = Net::HTTP::Put.new(uri, content) if type == 'update'
      request['x-api-key'] = api_key
      request.body = request_params.to_json

      r = http.request(request)
      response = r.read_body
    end

    [response, errors]
  end
end
