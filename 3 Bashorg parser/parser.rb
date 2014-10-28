#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'
require 'pry'
require 'json'


def parse_quote (element)
	quote_hash = {}

	#   Check if this is valid quote -> workaround
	if element.at_xpath("descendant-or-self::node()/script[@type = 'text/javascript']")
		# binding.pry
		return nil
	end

	quote_hash[:text] 	= element.at_xpath("div[@class = 'text']").text
	quote_hash[:rating]	= element.at_xpath("descendant::node()/span[@class = 'rating']").text.to_i
	quote_hash[:date] 	= element.at_xpath("descendant::node()/span[@class = 'date']").text
	quote_hash[:id] 	= element.at_xpath("descendant::node()/a[@class = 'id']").text.delete('#').to_i

	# binding.pry
	return quote_hash
end

def quotes_from_page (page)
	#   Get quotes
	quotes_array = []
	result = page.search("//div[@class = 'quote']").find_all

	#   Parse quote
	result.each { |quote|
		quotes_array << parse_quote(quote)
	}
	# binding.pry
	return quotes_array
end

def print_progress (progress)
	# clear = TermInfo.control_string 'el'
	clear = "\e[K"
	print "\r#{clear}#{progress}\n"
	STDOUT.flush
end

#//////////////////////////////////////////////////////////////

agent = Mechanize.new

#   Get bash.im -> random
page = agent.get('http://bash.im')

puts 'Start parsing bash.im'
f = File.new("/Users/VaHo/Desktop/parser_output.txt",  "w+")
array_of_results = []

while page do

	current_page_number = page.at("span[@class = 'current']/input")[:value].to_i
	max_page_number 	= page.at("span[@class = 'current']/input")[:max].to_i
	print_progress("Pages left/max: #{current_page_number}/#{max_page_number}")
	# binding.pry

	array_of_results.concat(quotes_from_page(page))

	#   Get next page
	links_for_next_page = agent.page.links.find { |l| 
		# binding.pry
		result = false
		arrow_element = l.node.at_xpath("span[@class = 'arr']/text()")
		if arrow_element
			result = arrow_element.text == '→'
		end
		# binding.pry if result
		result
	}

	# binding.pry
	if links_for_next_page
		page = links_for_next_page.click
	else
		page = nil
	end

end

f << JSON.pretty_generate(array_of_results.compact)
f.close
puts 'Finished'

