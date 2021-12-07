# input = [16,1,2,0,4,2,7,1,2,14]
input = File.read("input.txt").split(",").map(&:to_i)

def actual(value)
  # return value
  return 0 if value == 0
  value + actual(value - 1)
end

positions = input.group_by{|x| x }.transform_values { |values| values.count }

estimations = {}
ignore_position = false
limit = 1000000000000000000

(positions.keys.min..positions.keys.max).each do |p|
  fuel_for_position = 0

  positions.keys.each do |pp|
    next if pp == p

    fuel_for_position += actual((pp - p).abs) * positions[pp]
    
    if fuel_for_position > limit
      fuel_for_position = -1
      break
    end
  end

  next if fuel_for_position == -1

  estimations = {
    position: p,
    fuel: fuel_for_position
  }
  limit = fuel_for_position
end

puts "Position #{estimations[:position]} - Fuel : #{estimations[:fuel]}"

# Part 1 : 349 - 356992
# Part 2 : 489 - 101268110