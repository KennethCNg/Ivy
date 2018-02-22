require 'sinatra'
require 'json'
load './web_scraper.rb'

get '/' do
    content_type :json
    fetch_data.to_json
end