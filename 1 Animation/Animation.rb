#!/usr/bin/env ruby

class Image

	def initialize
		currentDir = File.dirname(__FILE__)
		fileName = File.join(currentDir, 'human body')
		chmoded = 0
		begin
			file = File.open(fileName)
			@human = file.read
		rescue
		  	File.chmod(0644, fileName) rescue nil
		  	chmoded += 1
		  	retry if chmoded < 2
	  	ensure
	  		file.close
		end
	end

	def humanWidth
		30
	end

	def humanHeight
		25
	end

	def drawHuman (offset) 
		@human.each_line {|s| 
			puts ' ' * offset << s
		}
	end

	def drawHumanReverse (offset)
		@human.each_line {|s|
			str = s
			str.reverse!.slice! "\n"
			puts ' ' * offset << str
		}
	end

	def drawGround (start, end_)
		puts ' ' * start << '/' * (end_ - start)
	end

	def self.clear
		system("clear")
	end
end

#--------------------------------------------------------

Image.clear
image = Image.new


startPoint = 20
distance = 30
frameDuration = 0.017	# 1/60

loop {
	#  Animate human forwards
	distance.times { |i|
		puts
		image.drawHuman(startPoint + i)
		image.drawGround(0, startPoint * 2 + distance + image.humanWidth)
		sleep(frameDuration)
		Image.clear
	}
	#  Animate human backwards
	distance.times { |i|
		puts
		image.drawHumanReverse(startPoint + distance - i)
		image.drawGround(0, startPoint * 2 + distance + image.humanWidth)
		sleep(frameDuration)
		Image.clear
	}
}
 


