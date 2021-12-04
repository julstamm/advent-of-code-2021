file = File.read("input.txt").split("\n")

input = []
File.readlines("input.txt").each do |line|
  direction, value = line.split(" ")
  input << {
    direction: direction,
    value: value.to_i
  }
end

puts "## Part 1"

horizontal_position = 0
depth = 0

input.each do |i|
  case i[:direction]
  when "forward"
    horizontal_position += i[:value]
  when "up"
    depth -= i[:value]
  when "down"
    depth += i[:value]
  end
end

puts "Result: #{horizontal_position * depth}" # 2039912

puts ""
puts "## Part 2"

horizontal_position = 0
depth = 0
aim = 0

input.each do |i|
  case i[:direction]
  when "forward"
    horizontal_position += i[:value]
    depth += (aim * i[:value])
  when "up"
    aim -= i[:value]
  when "down"
    aim += i[:value]
  end
end

puts "Result: #{horizontal_position * depth}" # 1942068080
