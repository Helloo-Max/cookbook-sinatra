require 'nokogiri'
require 'open-uri'

class ScrapeAllRecipes
  def scrape_website(query)
    url = "https://www.allrecipes.com/search/results/?search=#{query}"
    doc = Nokogiri::HTML(URI.open(url).read, nil, 'utf-8')
    result = [] #=> {:name=>"Peppermint White Hot Chocolate", :description=>"Perfect and elegant for Thanksgiving..."}

    # Scrapes only the first 5 entries to avoid blacklisting
    doc.search(".card__recipe").first(5).each do |card|
      scraped_name = card.css(".card__title").text.strip
      scraped_description = card.css(".card__summary").text.strip
      scraped_rating = card.css(".review-star-text").text.gsub(/\D/, '').to_i / 100

      # Getting the URL's of recipes to scrape the prep time
      recipe_url = card.search(".card__imageContainer a").first.attribute("href").value
      recipe_doc = Nokogiri::HTML(URI.open(recipe_url), nil, 'utf-8')
      prep_element = recipe_doc.search(".recipe-meta-item").find do |item|
        item.text.strip.match?(/prep/i) #=> validation, if there is a prep entry
      end

      if prep_element #=> if there is an entry...
        scraped_pt = prep_element.text.strip.match(/prep:\s+(\w* \w*)/i)[1]
      else
        scraped_pt = nil
      end

      result << { name: scraped_name, description: scraped_description, rating: scraped_rating, prep_time: scraped_pt }
    end
    result
  end
end
