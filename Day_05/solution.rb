require "ostruct"

# TODO
# - Make the Diagram size dynamic
# - Make the segment's points more readable

input = %{
  8,0 -> 0,8
  0,0 -> 8,8
  0,9 -> 5,9
  9,4 -> 3,4
  2,2 -> 2,1
  7,0 -> 7,4
  6,4 -> 2,0
  0,9 -> 2,9
  3,4 -> 1,4
  5,5 -> 8,2
}
input = File.read("input.txt")
segment_data_str = input.split("\n").reject(&:empty?)

class Segment
  attr_accessor :coordinates

  def initialize(line_raw)
    coordinates_raw = line_raw.split("->").map(&:strip)
    @coordinates = []
    coordinates_raw.each do |c|
      x, y = c.split(",").map(&:to_i)
      @coordinates << OpenStruct.new(x: x, y: y)
    end
  end

  def points
    coordinate_start = coordinates.first
    coordinate_end = coordinates.last
    
    if (coordinate_start.x == coordinate_end.x)
      # Vertical line
      start_draw, end_draw = [coordinate_start.y, coordinate_end.y].minmax
      (start_draw..end_draw).each do |intermediate_y|
        yield(coordinate_start.x, intermediate_y)
      end
    end

    if (coordinate_start.y == coordinate_end.y)
      # Horizontal line
      start_draw, end_draw = [coordinate_start.x, coordinate_end.x].minmax
      (start_draw..end_draw).each do |intermediate_x|
        yield(intermediate_x, coordinate_start.y)
      end
    end

    if (coordinate_end.x - coordinate_start.x).abs == (coordinate_end.y - coordinate_start.y).abs
      # Diagonal line
      diff = 0
      if coordinate_start.x < coordinate_end.x
        (coordinate_start.x..coordinate_end.x).each do |intermediate_x|
          yield(intermediate_x, coordinate_start.y + diff)
          if coordinate_start.y > coordinate_end.y
            diff -= 1
          else
            diff += 1
          end          
        end
      else
        (coordinate_end.x..coordinate_start.x).each do |intermediate_y|
          yield(intermediate_y, coordinate_end.y + diff)
          if coordinate_end.y > coordinate_start.y
            diff -= 1
          else
            diff += 1
          end          
        end
      end
    end
  end
end

class Cell
  attr_accessor :value

  def initialize(value)
    @value = value
  end

  def to_s
    (@value == 0 ? '.' : @value.to_s)
  end

  def increment!
    @value += 1
  end
end

class Diagram
  attr_accessor :overlapping_cells_count

  def initialize()
    @lines = 1000.times.map {|y| 1000.times.map {|x| Cell.new(0) } }
    @overlapping_cells_count = 0
  end

  def process_segment(segment)
    overlapping_cells_count = 0
    segment.points do |x, y|
      update_diagram(x, y)
    end
  end

  def to_s
    result = ""
    @lines.each do |cells|
      line = ""
      cells.each do |cell|
        line << cell.to_s
      end
      result += line + "\n"
    end
    result
  end

  private

  def update_diagram(x, y)
    cell = @lines[y][x]
    cell.increment!
    @overlapping_cells_count += 1 if cell.value == 2
  end
end

segments = segment_data_str.map {|segment_str| Segment.new(segment_str) }
diagram = Diagram.new

segments.each do |segment|
  diagram.process_segment(segment)
end

# puts diagram.to_s

puts "Result : #{diagram.overlapping_cells_count}"

# To export result:
# File.open("output.txt", 'w') { |file| file.write(diagram.to_s) }
