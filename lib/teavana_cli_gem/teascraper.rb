require 'open-uri'
require 'nokogiri'
require 'pry'

class TeavanaCliGem::TeaScraper
  # want to create a class array of teas that will puts out each tea
  # 1. Green Tea
  # 2. Black Tea 
  # etc.

  @@tea_types = [] # shovel tea types into this array
  @@tea_urls = [] # shovel tea type urls into this array

  def self.scrape_tea_types
    # scrape from teavana website index page
    index_url = "http://www.teavana.com/us/en/tea"
    doc = Nokogiri::HTML(open(index_url))

    doc.css("ul#by-type li").each do |type| # selects teas 'BY TYPE'
      # tea.text => "Green"
      @@tea_types << type.text unless @@tea_types.include?(type.text)
    end
    @@tea_types
  end

  def self.scrape_tea_urls
    # some method to get the href of selected tea
    # shovel each href into @@tea_urls array

    index_url = "http://www.teavana.com/us/en/tea"
    doc = Nokogiri::HTML(open(index_url))

    doc.css("ul#by-type li a").each do |type| # selects the 'a' element
      @@tea_urls << type["href"] unless @@tea_urls.include?(type["href"])
    end
    @@tea_urls
  end

  # def self.scrape_specific_tea_kinds(input)
  #   # calls on @tea_urls array and selects appropriate index_url using index #
  #   # index_url = user's number input
    
  #   scrape_tea_urls

  #   index_url = @@tea_urls[input.to_i-1]
  #   doc = Nokogiri::HTML(open(index_url))
  #   @specific_tea_kinds = []

  #   doc.css(".product_card").each do |card|
  #      @specific_tea_kinds << card.css(".name").text unless @specific_tea_kinds.include?(card.css(".name").text)
  #   end
  #   @specific_tea_kinds
  # end

  def self.scrape_specific_tea_kinds(input)
    # calls on @tea_urls array and selects appropriate index_url using index #
    # index_url = user's number input
    
    scrape_tea_urls

    index_url = @@tea_urls[input.to_i-1] + "?sz=1000&start=0&lazyload=true&format=ajax"

    doc = Nokogiri::HTML(open(index_url))

    @specific_tea_kinds = doc.css(".product_card").collect {|card| card.css(".name").text}
    
  end

  def self.list_specific_tea_kinds
    @specific_tea_kinds.each.with_index(1) do |tea,i|
      puts "#{i}. #{tea}"
    end
  end

  def self.list_tea_types
    scrape_tea_types
    @@tea_types.each.with_index(1) do |tea,i|
      puts "#{i}. #{tea}"
    end
  end

  def self.scrape_specific_tea_kinds_urls(input1)
    scrape_tea_urls
    index_url = @@tea_urls[input1-1] + "?sz=1000&start=0&lazyload=true&format=ajax"
    doc = Nokogiri::HTML(open(index_url))
    @specific_tea_kinds_urls = [] # array of urls for specific tea kinds for a single type of tea. Ex. Green => [url for matcha, url for dragon pearl]

      doc.css(".product_card .name a").each do |card|
         @specific_tea_kinds_urls << card["href"] unless @specific_tea_kinds_urls.include?(card["href"]) # url of each specific tea card (leads to tea details)
       end
    @specific_tea_kinds_urls
  end
 
  def self.scrape_tea_details(input2)
    @tea_details = {}
    index_url = @specific_tea_kinds_urls[input2-1] 

    doc = Nokogiri::HTML(open(index_url))
      price = "N/A"
      availability = "N/A"
      description = "N/A"
      tasting_notes = "N/A"
      caffeine_level = "N/A"
      ingredients = "N/A"

      price = doc.css(".pdp-price-div").css("div[itemprop]").text.gsub(/\t/,'').gsub(/\n/,'').gsub(/\r/,'')
      
      availability = doc.css(".pdp-avail").text.gsub(/\n/,'')

      description = doc.css("div#longdesc.open").text.gsub(/\n/,'').gsub(/\r/,'')
      
      unless doc.css("span.pdp-value.open").size == 0
        tasting_notes = doc.css("span.pdp-value.open").text
      end

      unless doc.css("input.caffeineLeveltxt").size == 0
        caffeine_level = doc.css("input.caffeineLeveltxt").attribute("value").value
      end

      unless doc.css(".ingredients.pdp-product-info").size == 0
        ingredients = doc.css(".ingredients.pdp-product-info").children[-2].text
      end
      
      # if hash, use '=', if array, use '<<'
      @tea_details = {:price => price, :availability => availability, :description => description, :tasting_notes => tasting_notes, :caffeine_level => caffeine_level, :ingredients => ingredients} 
      
      #@tea_details.reject! {|k,v| v.include?("N/A")} 
      @tea_details 
  end

end