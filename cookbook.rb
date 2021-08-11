require 'csv'

class Cookbook
  def initialize(csv_file_path)
    @recipes = [] #=> [#<Recipe:0x00007fe68d2808b8 @name="Raspberry-Infused Vodka", @description="Yummy...">]
    @csv_file_path = csv_file_path
    load_csv
  end

  # Returns all recipes
  def all
    @recipes
  end

  # Adds a new recipe to the cookbook
  def add_recipe(recipe)
    @recipes << recipe
    save_csv
  end

  # Update the 'tried' status
  def update_status
    save_csv
  end

  # Removes a recipe from the cookbook
  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    save_csv
  end

  private

  # Loads existing recipes from the csv.file
  def load_csv
    CSV.foreach(@csv_file_path) do |row|
      @recipes << Recipe.new(name: row[0], description: row[1], rating: row[2], prep_time: row[3], tried: row[4])
    end
  end

  # Opens last version of array and saves to csv.file
  def save_csv
    CSV.open(@csv_file_path, 'wb') do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.rating, recipe.prep_time, recipe.tried]
      end
    end
  end
end
