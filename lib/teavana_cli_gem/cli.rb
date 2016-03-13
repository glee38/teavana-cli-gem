require 'open-uri'
require 'nokogiri'
require 'pry'

class TeavanaCliGem::CLI

  def call
    # here doc - puts out multiple strings
    # got rid of leading whitespace chars via #gsub
    # puts <<-DOC.gsub /^\s+/, ""
    # Welcome to Teavana!
    # DOC
    # select_tea_type

    puts "Welcome to Teavana!".colorize(:green)
    select_tea_type
  end

  def tea_types # lists types of tea
    puts "Here is our menu of available types of tea:".colorize(:yellow)
    puts "Home > Tea".colorize(:red)
    @teas = TeavanaCliGem::TeaScraper.list_tea_types
    puts "Please enter the number of the tea you are interested in.".colorize(:cyan)
    puts "For example, if you would like to view our menu of #{@teas[0]} Teas, enter '1'.".colorize(:cyan)
  end

  def select_tea_type # selects type of tea - Green, Black, etc.
    tea_types
    @input_1 = nil
    while @input_1 != "exit"
      @input_1 = gets.strip

      if @input_1.to_i > 0 && @input_1.to_i <= @teas.size
        puts "You have selected #{@teas[@input_1.to_i-1]} Tea.".colorize(:yellow)
        puts "Home > Tea > ".colorize(:red) + "#{@teas[@input_1.to_i-1]} Tea".colorize(:red).underline
        # following three lines should be inside a method
        TeavanaCliGem::TeaScraper.scrape_specific_tea_kinds(@input_1)
        @tea_kinds = TeavanaCliGem::TeaScraper.list_specific_tea_kinds
        select_tea_kind
      elsif @input_1.downcase == "home"
        tea_types
      elsif @input_1.downcase == "exit"
        break
      else
        puts "Oops! We are not sure what you were looking for. Please type 'home' to go back to the menu of available teas or 'exit'."
      end
      break if @do_break
    end
    puts "Thank you for browsing Teavana! We hope to see you again!"
  end

  def select_tea_kind # selects specific kinds of tea - Dragonwell Green Tea, etc
    @input_2 = nil
    puts "Which tea would you like to know more about?".colorize(:cyan)
    puts "For example, if you would like more details on #{@tea_kinds[0]}, enter '1'.".colorize(:cyan)
    puts "(Enter 'home' to go back to the menu of all available teas or 'exit'.)".colorize(:magenta)

    while @input_2 != "exit"
      @input_2 = gets.strip

      if @input_2.to_i > 0 && @input_2.to_i <= @tea_kinds.size
        puts "You have selected #{@tea_kinds[@input_2.to_i-1]}.".colorize(:yellow)
        puts "Home > Tea > #{@teas[@input_1.to_i-1]} Tea > ".colorize(:red) + "#{@tea_kinds[@input_2.to_i-1]}".colorize(:red).underline
      list_tea_details
      puts "(Enter 'back' to go back to the menu of #{@teas[@input_1.to_i-1]} Teas, 'home' to go back to the menu of all available teas, or 'exit'.)".colorize(:magenta)
      elsif @input_2.downcase == "back"
        puts "Home > Tea > ".colorize(:red) + "#{@teas[@input_1.to_i-1]} Tea".colorize(:red).underline
        TeavanaCliGem::TeaScraper.scrape_specific_tea_kinds(@input_1)
        @tea_kinds = TeavanaCliGem::TeaScraper.list_specific_tea_kinds
        select_tea_kind
      elsif @input_2.downcase == "home"
        select_tea_type
      elsif @input_2.downcase == "exit"
        @do_break = true # flag to break out of parent loop #select_tea_type
      else
        puts "Oops! We are not sure what you were looking for. Please type 'home' to go back to the menu of available teas or 'exit'."
      end
    end
  end

  def list_tea_details
    TeavanaCliGem::TeaScraper.scrape_specific_tea_kinds_urls(@input_1.to_i)
    TeavanaCliGem::TeaScraper.scrape_tea_details(@input_2.to_i)
    tea_details_hash = TeavanaCliGem::TeaScraper.tea_details
    tea = TeavanaCliGem::Teas.new(tea_details_hash)

    puts "PRICE".colorize(:blue)
    puts "#{tea.price}"
    puts "#{tea.availability}"
    puts "DESCRIPTION".colorize(:blue)
    puts "#{tea.description}"
    puts "TASTING NOTES".colorize(:blue)
    puts "#{tea.tasting_notes}"
    puts "CAFFEINE LEVEL".colorize(:blue)
    puts "#{tea.caffeine_level}"
    caffeine_guide
    puts "INGREDIENTS".colorize(:blue)
    puts "#{tea.ingredients}"
  end

  # def list_tea_details
  #   TeavanaCliGem::TeaScraper.scrape_tea_details(@input_1.to_i, @input_2.to_i)
  #   tea_details_hash = TeavanaCliGem::TeaScraper.tea_details
  #   tea = TeavanaCliGem::Teas.new(tea_details_hash)

  #   puts "PRICE".colorize(:blue)
  #   puts "#{tea.price}"
  #   puts "#{tea.availability}"
  #   puts "DESCRIPTION".colorize(:blue)
  #   puts "#{tea.description}"
  #   puts "TASTING NOTES".colorize(:blue)
  #   puts "#{tea.tasting_notes}"
  #   puts "CAFFEINE LEVEL".colorize(:blue)
  #   puts "#{tea.caffeine_level}"
  #   caffeine_guide
  #   puts "INGREDIENTS".colorize(:blue)
  #   puts "#{tea.ingredients}"
  # end

  def caffeine_guide
    puts "CAFFEINE GUIDE".colorize(:blue)
    puts <<-DOC.gsub /^\s+/, ""
    4: 40+ MG
    3: 26-39 MG
    2: 16-25 MG
    1: 1-15 MG
    0: CAFFEINE-FREE
    DOC
  end

end