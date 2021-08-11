# Acts as the Router and the Controller of the MVC app

require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
set :bind, '0.0.0.0'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('__dir__', __dir__)
end

require_relative 'recipe'
require_relative 'cookbook'
require_relative 'scrape_all_recipes'

# INDEX - renders the stored recipes.

get '/' do #=> Router part
  # [...] #=> Controller logic
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  @recipes = cookbook.all #=> defined instance variables in the Controller are automatically passed to the view
  erb :index
end

# CREATE - directs to a form and creates a new recipe.

get '/new' do
  erb :new
end

post '/recipes' do
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  pr = params
  recipe = Recipe.new(name: pr[:name], description: pr[:description], rating: pr[:rating], prep_time: pr[:prep_time])
  cookbook.add_recipe(recipe)
  redirect to('/')
end

# UPDATE (MARK) - changes the 'tried' status.

get '/recipes/:index/mark' do #=> ':index' here is the key of the params; can be named differently (e.g. 'abc')
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  recipe_index = params[:index].to_i
  recipe = cookbook.all[recipe_index]
  recipe.tried == 'false' ? recipe.tried = 'true' : recipe.tried = 'false'
  cookbook.update_status #=> saves to CSV
  redirect to('/')
end

# IMPORT - uses the query to scrape a recipe and save it to the CSV.

get '/import' do
  erb :import
end

post '/import/:recipe' do
  @query = params[:query] #=> e.g. 'coconut'
  scraped_recipe = ScrapeAllRecipes.new.scrape_website(@query) # Array with hashes
  @results = scraped_recipe
  erb :show_import
end

get '/import/:recipe/:index' do
  query = params[:recipe]
  index = params[:index].to_i

  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  scraped_recipe = ScrapeAllRecipes.new.scrape_website(query)
  recipe = Recipe.new(
    name: scraped_recipe[index][:name],
    description: scraped_recipe[index][:description],
    rating: scraped_recipe[index][:rating],
    prep_time: scraped_recipe[index][:prep_time]
  )
  cookbook.add_recipe(recipe)
  redirect to('/')
end

# DELETE - deletes the selected recipe.

get '/recipes/:index/delete' do
  cookbook = Cookbook.new(File.join(__dir__, 'recipes.csv'))
  recipe_index = params[:index].to_i
  cookbook.remove_recipe(recipe_index)
  redirect to('/')
end
