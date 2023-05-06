require 'net/http'
require 'uri'
require 'json'

API_KEY = "alOjhW5CqIj7AZp4FxZ1dYXJKGP6VtfgENCsQYyx"
URL = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=40&api_key=#{API_KEY}"

#metodo request
def request(url)
  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri)
  response = http.request(request)

  if response.code == "200"
    JSON.parse(response.body)
  else
    puts "Error: #{response.code} - #{response.message}"
    nil
  end
end

DATA = request(URL)
puts DATA #Aqui se imprimen la data de la API

#metodo build_web_page
def build_web_page(data)
  image_data = data["photos"].map { |photo| { img_src: photo["img_src"], full_name: photo["camera"]["full_name"] } }
  html = "<!DOCTYPE html>\n<html>\n<head>\n\t<title>Mars Rover Photos</title>\n\t<style>\n\t\tbody {\n\t\t\tdisplay: flex;\n\t\t\tjustify-content: center;\n\t\t\talign-items: center;\n\t\t}\n\t\timg {\n\t\t\twidth: 512px;\n\t\t}\n\t</style>\n</head>\n<body>\n\t<ul style=\"list-style-type: none; padding: 0; margin: 0;\">\n"
  image_data.each do |data|
    html += "\t\t<li><img src=\"#{data[:img_src]}\" alt=\"#{data[:full_name]}\"></li>\n"
  end
  html += "\t</ul>\n</body>\n</html>"
  File.write('index.html', html)
end

build_web_page(DATA)

#Metodo photos_count
def photos_count(response_hash)
  cameras_count = {}
  response_hash["photos"].each do |photo|
    camera_name = photo["camera"]["name"]
    if cameras_count[camera_name]
      cameras_count[camera_name] += 1
    else
      cameras_count[camera_name] = 1
    end
  end
  puts "*********************"
  puts "Cantidad de Camaras"
  puts cameras_count
end

photos_count(DATA)
