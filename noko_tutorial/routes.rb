require 'sinatra'
require 'json'
load './web_scraper.rb'

get '/birthday/:month/:day' do
    content_type :json
    fetch_data(params["month"], params["day"]).to_json
end