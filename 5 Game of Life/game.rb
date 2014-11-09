#!/usr/bin/env ruby

require 'pry'
require 'drawille'

# M = 60
# N = 60

LIVING_CONDITION = 2..3
GENESIS_CONDITION = 3

DEAD_SYMBOL = ' '
ALIVE_SYMBOL = '●'

def empty_generation(m, n)
	Array.new(m) {Array.new(n, DEAD_SYMBOL)}
end

def first_generation(m, n)
	Array.new(m) {Array.new(n) {(rand(2) == 1) ? ALIVE_SYMBOL : DEAD_SYMBOL}}
end

def calculate_neighbours(m, n, array)
	m_max = array.count
	n_max = array.first.count
	counter = 0

	(m - 1).upto(m + 1) do |e_m|
		(n - 1).upto(n + 1) do |e_n|
			neighbour = array[e_m.modulo(m_max)][e_n.modulo(n_max)]
			if (neighbour == ALIVE_SYMBOL && (e_m != m || e_n != n))
				counter += 1
			end
		end
	end
	return counter
end

def create_new_generation(start_array)
	# new_array = Marshal.load(Marshal.dump(start_array))
	new_array = empty_generation(start_array.count, start_array.first.count)
	start_array.each_with_index do |inner_array, outer_index|
		inner_array.each_with_index do |e, inner_index|
			neighbours_count = calculate_neighbours(outer_index, inner_index, start_array)
			# if (e == ALIVE_SYMBOL && !LIVING_CONDITION.include?(neighbours_count))
			# 	new_array[outer_index][inner_index] = DEAD_SYMBOL
			# elsif (e == DEAD_SYMBOL && neighbours_count == GENESIS_CONDITION)
			# 	new_array[outer_index][inner_index] = ALIVE_SYMBOL
			# end
			if (e == ALIVE_SYMBOL)
				new_array[outer_index][inner_index] = LIVING_CONDITION.include?(neighbours_count) ? ALIVE_SYMBOL : DEAD_SYMBOL
			else
				new_array[outer_index][inner_index] = (GENESIS_CONDITION == neighbours_count) ? ALIVE_SYMBOL : DEAD_SYMBOL
			end
		end
	end

	return new_array
end

# def draw_generation(array)
# 	clear = "\e[H\e[2J"
# 	print clear
# 	array.each do |inner_array|
# 		inner_array.each do |symbol|
# 			print symbol
# 		end
# 	end
# end

def to_canvas(world)
	canvas = Drawille::Canvas.new
	world.each_with_index do |line, m|
		line.each_with_index do |symbol, n|
			canvas.set(m, n) if world[m][n] == ALIVE_SYMBOL
		end
	end
	canvas
end

#======================================
#============MAIN======================
#======================================

# Get parameters
m = 0
n = 0

if (ARGV.count == 2)
	m = ARGV[0].to_i
	n = ARGV[1].to_i
else
	puts "Wrong parameters count: #{ARGV.count}, should be 2"
	exit
end

# Start game
generation = first_generation(m, n)
generation_counter = 0
prev_state_1 = 0;
prev_state_2 = 0;

flipbook = Drawille::FlipBook.new
flipbook.play do
	if (generation_counter.even?)
		prev_state_1 = generation.hash
	else
		prev_state_2 = generation.hash
	end
	canvas = to_canvas(generation)
	generation = create_new_generation(generation)
	if (generation.hash == prev_state_1 ||
		generation.hash == prev_state_2)
		break
	end
	generation_counter += 1 
	canvas
end
puts "Life ended after #{generation_counter} generations"

# draw_generation(generation)

# loop do
# 	sleep(0.05)
# 	new_array = create_new_generation(generation)
# 	draw_generation(new_array)
# 	generation_counter += 1 

# 	if (new_array.hash == generation.hash)
# 		puts "Generations #{generation_counter}"
# 		exit
# 	end
# 	generation = new_array
# end