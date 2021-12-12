example_1_input = File.read("example_1.txt")
example_2_input = File.read("example_2.txt")
example_3_input = File.read("example_3.txt")
input = File.read("input.txt")

class MapPart1
  def initialize(input)
    input.split("\n").each do |line|
      a, b = line.split("-")
      @node_options    ||= {}
      @node_options[a] ||= []
      @node_options[a] << b   unless @node_options[a].include?(b)
      @node_options[b] ||= []
      @node_options[b] << a   unless @node_options[b].include?(a)
    end
  end

  def get_paths
    process("start", []).map{|path| path.join(",") }
  end

  private

  def process(node, array)
    array << node
    if node == "end"
      return [array]
    else
      result = []
      @node_options[node].reject{|n| next_node_should_be_ignored(n, array) }.each do |next_node|
        next if next_node_should_be_ignored(next_node, array)
        process(next_node, array.dup).each do |x|
          result << x
        end
      end
      result
    end
  end

  def next_node_should_be_ignored(next_node, array)
    next_node == "start" ||
      (next_node == next_node.downcase &&
        array.include?(next_node)
      )
  end
end

class MapPart2 < MapPart1
  def next_node_should_be_ignored(next_node, array)
    return true if next_node == "start"
    return false if next_node == "end" || next_node != next_node.downcase
    downcase_nodes = array.select{|c| c != "start" && c == c.downcase }
    return false unless downcase_nodes.any?
    return false if downcase_nodes.group_by(&:itself).none?{|k,v| v.count > 1 }
    downcase_nodes.include?(next_node)
  end
end

paths = MapPart1.new(example_1_input).get_paths
raise unless paths.count == 10

paths = MapPart1.new(example_2_input).get_paths
raise unless paths.count == 19

paths = MapPart1.new(example_3_input).get_paths
raise unless paths.count == 226

paths = MapPart1.new(input).get_paths
raise unless paths.count == 3495
puts "Result : #{paths.count}"

paths = MapPart2.new(example_1_input).get_paths
raise unless paths.count == 36

paths = MapPart2.new(example_2_input).get_paths
raise unless paths.count == 103

paths = MapPart2.new(example_3_input).get_paths
raise unless paths.count == 3509

paths = MapPart2.new(input).get_paths
raise unless paths.count == 94849
puts "Result : #{paths.count}"
