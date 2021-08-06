# Acts as the Router and the Controller of the MVC app

require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do #=> Router part
  erb :index
  # [...] #=> Controller part
end

get '/about' do
  erb :about
end