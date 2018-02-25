require 'sinatra'
require 'json'
load './final_scraper.rb'

get '/' do
    content_type :json
    fetch_data.to_json
end