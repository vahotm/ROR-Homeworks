#!/usr/bin/env ruby

require 'pry'
require 'drawille'

class Life
	LIVING_CONDITION = 2..3
	GENESIS_CONDITION = 3

	DEAD_SYMBOL = ' '
	ALIVE_SYMBOL = '●'

	attr_accessor :generation
	attr_accessor :generation_count

	def initialize(width, height)
		@width = width
		@height = height
		@generation = first_generation(width, height)
		@generation_count = 0
	end

	def new_generation
		new_array = empty_generation(@width, @height)
		each do |m, n|
			neighbours_count = calculate_neighbours(m, n, @generation)
			if (@generation[n][m] == ALIVE_SYMBOL)
				new_array[n][m] = LIVING_CONDITION.include?(neighbours_count) ? ALIVE_SYMBOL : DEAD_SYMBOL
			else
				new_array[n][m] = (GENESIS_CONDITION == neighbours_count) ? ALIVE_SYMBOL : DEAD_SYMBOL
			end
		end
		@generation_count += 1
		# binding.pry
		@generation = new_array
	end

	def start_game
		prev_state_1 = 0;
		prev_state_2 = 0;
		# binding.pry

		flipbook = Drawille::FlipBook.new
		flipbook.play do
			if (@generation_count.even?)
				prev_state_1 = @generation.hash
			else
				prev_state_2 = @generation.hash
			end
			canvas = to_canvas
			new_generation
			if (@generation.hash == prev_state_1 ||
				@generation.hash == prev_state_2)
				break
			end
			canvas
		end
		puts "Life ended after #{@generation_count} generations"
	end

	#----------------------------------
	private

	def to_canvas
		canvas = Drawille::Canvas.new
		# binding.pry
		each do |m, n|
			canvas.set(m, n) if @generation[n][m] == ALIVE_SYMBOL
		end
		canvas
	end

	def empty_generation(width, height)
		Array.new(height) {Array.new(width, DEAD_SYMBOL)}
	end

	def first_generation(width, height)
		Array.new(height) {Array.new(width) {(rand(2) == 1) ? ALIVE_SYMBOL : DEAD_SYMBOL}}
	end

	def calculate_neighbours(m, n, array)
		width = array.first.count
		height = array.count
		counter = 0

		(m - 1).upto(m + 1) do |e_m|
			(n - 1).upto(n + 1) do |e_n|
				neighbour = array[e_n.modulo(height)][e_m.modulo(width)]
				if (neighbour == ALIVE_SYMBOL && (e_m != m || e_n != n))
					counter += 1
				end
			end
		end
		return counter
	end

	def each
		(0...@height).each do |n|
			(0...@width).each do |m|
				yield m, n
			end
		end
	end
end

#======================================
#============MAIN======================
#======================================

# Get parameters
width = 0
height = 0

if (ARGV.count == 2)
	width = ARGV[0].to_i
	height = ARGV[1].to_i
else
	puts "Wrong parameters count: #{ARGV.count}, should be 2"
	exit
end

# Start game
life = Life.new(width, height)
begin
	life.start_game
rescue Interrupt
	puts "\nLife interrupted after #{life.generation_count} generations"
  	exit!
end
