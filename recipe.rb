class Recipe
  attr_reader :name, :description, :rating, :prep_time
  attr_accessor :tried

  def initialize(attributes = {})
    @name = attributes[:name]
    @description = attributes[:description]
    @rating = attributes[:rating]
    @prep_time = attributes[:prep_time]
    @tried = attributes[:tried] || 'false'
  end
end
