require 'json'
require 'net/http'
require 'uri'

def query_consul(service)
  uri = URI.parse("http://localhost:8500/v1/catalog/service/#{service}")
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
 
  response = http.request(request)
 
  if response.code == "200"
    result = JSON.parse(response.body)
    result.first["Address"]
  else
    puts "ERROR!!!"
  end
end
