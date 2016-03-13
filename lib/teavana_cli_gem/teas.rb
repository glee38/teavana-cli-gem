class TeavanaCliGem::Teas
  attr_accessor :name, :availability, :price, :description, :tasting_notes, :caffeine_level, :ingredients # add :caffeine_guide later

  @@all = []

  def initialize(tea_attributes_hash) # take in an argument of the TeaScraper class
    self.add_tea_attributes(tea_attributes_hash)
    @@all << self unless @@all.include?(self)
  end

  def add_tea_attributes(tea_attributes_hash)
    tea_attributes_hash.each do |k,v|
      send("#{k}=", v) unless v == nil
    end
    self
  end

  def self.all
    @@all
  end
end