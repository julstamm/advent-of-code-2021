file = File.read("input.txt").split

puts "## Part 1"

counter = 0

(1..file.length - 1).each do |i|
  counter += 1 if (file[i - 1].to_i < file[i].to_i)
end

puts "Result: #{counter}"

puts ""
puts "## Part 2"

counter = 0

(3..file.length - 1).each do |i|
  sum_1 = file[i - 3].to_i + file[i - 2].to_i + file[i - 1].to_i
  sum_2 = file[i - 2].to_i + file[i - 1].to_i + file[i].to_i
  counter += 1 if (sum_1 < sum_2)
end

puts "Result: #{counter}"
