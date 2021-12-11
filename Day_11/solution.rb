input = <<HEREDOC
11111
19991
19191
19991
11111
HEREDOC

input = <<HEREDOC
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
HEREDOC

input = File.read("input.txt")

class Octopus
  attr_accessor :x, :y, :level, :has_flashed

  def initialize(x, y, level)
    @x, @y, @level = x, y, level
    @has_flashed = false
  end

  def next!(array)
    @level += 1 unless @has_flashed

    if @level > 9
      @@counter += 1
      @level = 0
      @has_flashed = true

      neighbours_to_update = []
      if @y > 0
        neighbours_to_update << array[(@y - 1)][(@x - 1)] if @x > 0
        neighbours_to_update << array[(@y - 1)][(@x)]
        neighbours_to_update << array[(@y - 1)][(@x + 1)] if @x < array.count - 1
      end
  
      neighbours_to_update << array[(@y)][(@x - 1)] if @x > 0
      neighbours_to_update << array[(@y)][(@x + 1)] if @x < array.count - 1
  
      if @y < array.count - 1
        neighbours_to_update << array[(@y + 1)][(@x - 1)] if @x > 0
        neighbours_to_update << array[(@y + 1)][(@x)]
        neighbours_to_update << array[(@y + 1)][(@x + 1)] if @x < array.count - 1
      end

      neighbours_to_update.each{|n| n.next!(array) }
    end
  end

  def end_step!
    @has_flashed = false
  end
end

@@counter = 0

octupus_array = []
input.split("\n").map{|l| l.split("").map(&:to_i) }.each_with_index do |octopuses, y|
  line = []
  octopuses.each_with_index do |level, x|
    line << Octopus.new(x, y, level)
  end
  octupus_array << line
end

def print_array(array)
  array.each do |line|
    puts line.map(&:level).join
  end
end

puts "Before any steps:"
print_array(octupus_array)
puts ""

i = 0

loop do
  octupus_array.each do |line|
    line.each do |o|
      o.next!(octupus_array)
    end
  end

  octupus_array.each do |line|
    line.each do |o|
      o.end_step!
    end
  end

  puts "After step #{i + 1}:"
  print_array(octupus_array)
  puts "Flashes : #{@@counter}"

  if octupus_array.all?{|l| l.all?{|o| o.level == 0 } }
    break
  end

  i += 1
end
