#!/usr/bin/env ruby

# trap("SIGINT") { throw :ctrl_c }

#  catch :ctrl_c do
#  begin
#     loop do
#     	puts 'puts'
#     	sleep 0.5
#     end
#  rescue Exception
#     puts "Interrupted"
#  end
#  end

begin
    loop do
    	puts 'puts'
    	sleep 0.5
    end
rescue Interrupt
	puts "\nInterrupt"
  	exit!
end