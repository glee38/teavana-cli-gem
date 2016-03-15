require 'open-uri'
require 'nokogiri'
require 'pry'


class TeavanaCliGem::CLI

  def call
    puts "Welcome to " + "Teavana".colorize(:green) + "!"
    select_tea_type
    goodbye
  end

  def goodbye
    puts "Thank you for browsing " + "Teavana".colorize(:green) + "! We hope to see you again!"
  end

  def tea_types # lists types of tea
    puts "Here is our menu of available types of tea:".colorize(:yellow)
    puts "Home > Tea".colorize(:red)
    puts " "
    @teas = TeavanaCliGem::TeaScraper.list_tea_types
    puts " "
    puts "Please enter the number of the tea you are interested in.".colorize(:cyan)
    puts "For example, if you would like to view our menu of #{@teas[0]} Teas, enter '1'.".colorize(:cyan)
  end

  def select_tea_type # selects type of tea - Green, Black, etc.
    tea_types

    begin
      @input_1 = gets.strip
      if @input_1.to_i > 0 && @input_1.to_i <= @teas.size
        puts " "
        puts "You have selected #{@teas[@input_1.to_i-1]} Tea.".colorize(:yellow)
        puts "Home > Tea > ".colorize(:red) + "#{@teas[@input_1.to_i-1]} Tea".colorize(:red).underline
        puts " "
        list_and_select_tea_kind
      elsif @input_1.downcase == "exit"
        puts "Please type 'exit' again to confirm.".colorize(:magenta) 
        # need to type 'exit' again to actually exit out of loop
        # only need to type it twice if user types 'home' from #select_tea_kind loop and then tries to exit
        # cannot figure out why when @input_1 is clearly 'exit' - used the 'break' keyword here to break out of the loop and it still didn't work
        # tried multiple ways to make it break out, none worked
      else
        puts "Oops! We are not sure what you were looking for. Please type 'home' to go back to the menu of available teas or 'exit'.".colorize(:magenta)
      end
      break if @do_break
    end while @input_1 != "exit"
  end

  def select_tea_kind # selects specific kinds of tea - Dragonwell Green Tea, etc
    puts " "
    puts "Which tea would you like to know more about?".colorize(:cyan)
    puts "For example, if you would like more details on #{@tea_kinds[0]}, enter '1'.".colorize(:cyan)
    puts "(Enter 'home' to go back to the menu of all available teas or 'exit'.)".colorize(:magenta)

    begin
      @input_2 = gets.strip

      if @input_2.to_i > 0 && @input_2.to_i <= @tea_kinds.size
        puts " "
        puts "You have selected #{@tea_kinds[@input_2.to_i-1]}.".colorize(:yellow)
        puts "Home > Tea > #{@teas[@input_1.to_i-1]} Tea > ".colorize(:red) + "#{@tea_kinds[@input_2.to_i-1]}".colorize(:red).underline
        puts " "
      list_tea_details
      puts "(Enter 'back' to go back to the menu of #{@teas[@input_1.to_i-1]} Teas, 'home' to go back to the menu of all available teas, or 'exit'.)".colorize(:magenta)
      elsif @input_2.downcase == "back"
        puts " "
        puts "Home > Tea > ".colorize(:red) + "#{@teas[@input_1.to_i-1]} Tea".colorize(:red).underline
        puts " "
        list_and_select_tea_kind
      elsif @input_2.downcase == "home"
        puts " "
        select_tea_type
      elsif @input_2.downcase == "exit"
        @do_break = true # flag to break out of parent loop #select_tea_type 
      else
        puts "Oops! We are not sure what you were looking for. Please type 'home' to go back to the menu of available teas or 'exit'.".colorize(:magenta)
      end
    end while @input_2 != "exit"
  end

  def list_and_select_tea_kind
    TeavanaCliGem::TeaScraper.scrape_tea_urls
    TeavanaCliGem::TeaScraper.scrape_specific_tea_kinds(@input_1)
    @tea_kinds = TeavanaCliGem::TeaScraper.list_specific_tea_kinds
    select_tea_kind
  end

  def list_tea_details
    TeavanaCliGem::TeaScraper.scrape_specific_tea_kinds_urls(@input_1.to_i)
    tea_details_hash = TeavanaCliGem::TeaScraper.scrape_tea_details(@input_2.to_i)
    tea = TeavanaCliGem::Teas.new(tea_details_hash)

    puts "PRICE".colorize(:blue)
    puts "#{tea.price}"
    puts "#{tea.availability}"
    puts " "
    puts "DESCRIPTION".colorize(:blue)
    puts "#{tea.description}"
    puts " "
    puts "TASTING NOTES".colorize(:blue)
    puts "#{tea.tasting_notes}"
    puts " "
    puts "CAFFEINE LEVEL".colorize(:blue)
    puts "#{tea.caffeine_level}"
    puts " "
    caffeine_guide
    puts " "
    puts "INGREDIENTS".colorize(:blue)
    puts "#{tea.ingredients}"
    puts " "
  end

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