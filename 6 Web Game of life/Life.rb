#!/usr/bin/env ruby

require 'pry'
require 'drawille'

Point = Struct.new(:x, :y)

class Life
	LIVING_CONDITION = 2..3
	GENESIS_CONDITION = 3

	DEAD_SYMBOL = 0
	ALIVE_SYMBOL = 1

	attr_accessor :generation
	attr_accessor :generation_count
	attr_accessor :width
	attr_accessor :height

	def initialize(width, height, initial_generation = nil)
		@width = width
		@height = height
		if initial_generation
			@generation = initial_generation
		else
			@generation = first_generation(width, height)
		end
		@generation_count = 0
		@to_reverse = []
	end

	def new_generation
		@to_reverse.clear
		each do |m, n|
			neighbours_count = calculate_neighbours(m, n, @generation)
			if (@generation[n][m] == ALIVE_SYMBOL &&
				!LIVING_CONDITION.include?(neighbours_count) ||
				@generation[n][m] == DEAD_SYMBOL &&
				neighbours_count == GENESIS_CONDITION)

				@to_reverse << Point.new(m, n)
			end
		end

		@to_reverse.each do |point|
			if (@generation[point.y][point.x] == ALIVE_SYMBOL)
				@generation[point.y][point.x] = DEAD_SYMBOL
			else
				@generation[point.y][point.x] = ALIVE_SYMBOL
			end
		end

		@generation_count += 1
		@generation
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