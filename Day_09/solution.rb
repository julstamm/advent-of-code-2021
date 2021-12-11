input = %{
2199943210
3987894921
9856789892
8767896789
9899965678
}

input = File.read("input.txt")

class Point
  attr_accessor :x, :y, :height, :height_map, :adjacent_points

  def initialize(x, y, height_map)
    @x = x
    @y = y
    @height = height_map[y][x]
    @height_map = height_map
  end

  def is_low_point?
    adjacent_points.all?{|p| p.height > height }
  end

  def risk_level
    height + 1
  end

  def unique_id
    "#{x},#{y}"
  end

  def basin_points(current_list)
    current_list << unique_id

    points = adjacent_points.select{|ap| ap.height < 9 && current_list.none?(ap.unique_id) }

    points.each do |p|
      next if current_list.include?(p.unique_id)
      current_list = p.basin_points(current_list)
    end

    current_list.flatten
  end

  private

  def adjacent_points
    @_adjacent_points ||= build_adjacent_points
  end

  def build_adjacent_points
    result = []

    # adj vertical
    if y - 1 >= 0
      result << build_point(x, y - 1)
    end
    if (y + 1) < height_map.count
      result << build_point(x, y + 1)
    end

    # adj horizontal
    if x - 1 >= 0
      result << build_point(x - 1, y)
    end
    if (x + 1) < height_map[y].count
      result << build_point(x + 1, y)
    end

    result
  end

  def build_point(x, y)
    Point.new(x, y, height_map)
  end
end

class Bassin
  attr_reader :low_point, :height_map

  def initialize(low_point)
    @low_point = low_point
    @height_map = height_map
  end

  def size
    result = low_point.basin_points([])

    result.count
  end
end

height_map = []

input.split("\n").each do |line_raw|
  line = []
  line_raw.split("").each do |height_raw|
    line << height_raw.to_i
  end
  height_map << line if line.count != 0
end

points = []

height_map.each_with_index do |line, i_line|
  line.each_with_index do |_, i_column|
    points << Point.new(i_column, i_line, height_map)
  end
end

low_points = points.select{|p| p.is_low_point? }

sizes = []

low_points.each do |lp|
  sizes << Bassin.new(lp).size
end

puts sizes.sort.last(3).inject(1) {|result, x| result * x }