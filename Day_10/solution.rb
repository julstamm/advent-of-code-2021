input = <<HEREDOC
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
HEREDOC

input = File.read("input.txt")

class Line
  attr_accessor :first_illegal_character, :line_raw

  CHUNK_TYPES = [
    ['(', ')'],
    ['[', ']'],
    ['{', '}'],
    ['<', '>']
  ]

  def initialize(line_raw)
    @line_raw = line_raw
    @stack = []
  end

  def is_corrupted?
    @line_raw.split("").each do |char|
      
      opening = CHUNK_TYPES.index{|ct| ct[0] == char }
      closing = CHUNK_TYPES.index{|ct| ct[1] == char }
      if opening
        @stack.push(opening)
      elsif closing
        if @stack.last == closing
          @stack.pop
        else
          # raise StandardError, "Invalid line"
          @first_illegal_character = CHUNK_TYPES[closing][1]
          return true
        end
      else
        raise StandardError, "Invalid character"
      end
    end
    false
  end

  def completion_string
    @stack = []

    @line_raw.split("").each do |char|
      opening = CHUNK_TYPES.index{|ct| ct[0] == char }
      closing = CHUNK_TYPES.index{|ct| ct[1] == char }
      if opening
        @stack.push(char)
      elsif closing
        if CHUNK_TYPES.index{|ct| ct[0] == @stack.last } && CHUNK_TYPES.index{|ct| ct[1] == char }
          @stack.pop
        end
      end
    end
    
    return nil if @stack.empty?
    completion_string = ""

    @stack.reverse.each do |cc|
      opening = CHUNK_TYPES.index{|ct| ct[0] == cc }
      if opening
        completion_string += CHUNK_TYPES[opening][1]
      end
    end

    completion_string
  end
end

valid_lines = []
corrupted_lines = []

input.split("\n").each do |line|
  line_obj = Line.new(line)
  if line_obj.is_corrupted?
    corrupted_lines << line_obj
  else
    valid_lines << line_obj
  end
end

def points_for_character(character)
  case character
  when ")"
    3
  when "]"
    57
  when "}"
    1197
  when ">"
    25137
  end
end

# Part 1
score =
  corrupted_lines.inject(0) do |result, line|
    result + points_for_character(line.first_illegal_character)
  end

puts "Score : #{score}"

# Part 2
def points_for_autocomp_character(character)
  case character
  when ")"
    1
  when "]"
    2
  when "}"
    3
  when ">"
    4
  end
end

def points_for_line(line)
  score = 0
  line.split("").each do |character|
    score *= 5
    score += points_for_autocomp_character(character)
  end
  score
end

completion_string_score = []

valid_lines.each do |line|
  comp_str = line.completion_string
  completion_string_score << points_for_line(line.completion_string) unless comp_str.empty?
end

completion_string_score.sort!

puts "Score : #{completion_string_score[(completion_string_score.count / 2)]}"
