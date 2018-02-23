require 'sinatra'
require 'json'
load './web_scraper.rb'

get '/' do
    content_type :json
    {
        "hello": "hello"
    }.to_json
end