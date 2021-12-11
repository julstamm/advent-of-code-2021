input = "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
  edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
  fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
  fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
  aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
  fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
  dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
  bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
  egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
  gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"

input = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
input = File.read("input.txt")

class Entry
  attr_accessor :signal_patterns, :output_characters

  CHARACTER_DEFINITIONS = {
    "0" => %w[ a b c e f g ],
    "1" => %w[ c f ],
    "2" => %w[ a c d e g ],
    "3" => %w[ a c d f g ],
    "4" => %w[ b c d f ],
    "5" => %w[ a b d f g ],
    "6" => %w[ a b d e f g ],
    "7" => %w[ a c f ],
    "8" => %w[ a b c d e f g ],
    "9" => %w[ a b c d f g ]
  }

  def initialize(entry)
    signal_patterns_raw, output_characters_raw = entry.split("|").map(&:strip)
    @signal_patterns = signal_patterns_raw.split(" ")
    @output_characters = output_characters_raw.split(" ")
  end

  def calculate_ouput
    result = ""
    @output_characters.each do |oc|
      display_characters_array = translate_character(oc)
      result << CHARACTER_DEFINITIONS.select{|k, v| v.sort == display_characters_array.sort }.first[0]
    end
    result.to_i
  end

  private

  def translate_character(output_character)
    output_character.split("").map do |connection_to_translate|
      final_led_zone = alternate_configuration[connection_to_translate]

      initial_configuration = {
        "a" => "0",
        "b" => "1",
        "c" => "2",
        "d" => "3",
        "e" => "4",
        "f" => "5",
        "g" => "6",
      }
      initial_configuration.select {|k, v| v == final_led_zone }.first[0]
    end
  end

  def alternate_configuration
    return @_alternate_configuration if defined?(@_alternate_configuration)

    temp2 = {
      "0" => [],
      "1" => [],
      "2" => [],
      "3" => [],
      "4" => [],
      "5" => [],
      "6" => [],
      "7" => [],
      "8" => [],
      "9" => [],
    }

    @signal_patterns.each do |sp|
      # '1'
      if sp.length == 2
        sp.split("").each do |cc|
          temp2["1"] << cc
        end
      end

      # '7'
      if sp.length == 3
        sp.split("").each do |cc|
          temp2["7"] << cc
        end
      end

      # '4'
      if sp.length == 4
        sp.split("").each do |cc|
          temp2["4"] << cc
        end
      end

      # '8'
      if sp.length == 7
        sp.split("").each do |cc|
          temp2["8"] << cc
        end
      end
    end
    
    # '2', '3' and '5'
    _other = @signal_patterns.select{|sp| (sp.length == 5) }.group_by {|sp| ((temp2["7"] | temp2["4"]) - sp.split("")).length }
    _other[2].first.split("").each do |cc|
      temp2["2"] << cc
    end
    _other[1].select{|sp| (sp.split("") - temp2["7"]).length == 2 }.first.split("").each do |cc|
      temp2["3"] << cc
    end
    _other[1].select{|sp| sp != temp2["3"].join }.first.split("").each do |cc|
      temp2["5"] << cc
    end

    # '9', '3' and '5'
    _other = @signal_patterns.select{|sp| (sp.length == 6) }.group_by {|sp| (sp.split("") - temp2["3"]).length }
    _other[1].first.split("").each do |cc|
      temp2["9"] << cc
    end
    _other[2].select{|sp| (sp.split("") - temp2["5"]).length == 1 }.first.split("").each do |cc|
      temp2["6"] << cc
    end
    _other[2].select{|sp| sp != temp2["6"].join }.first.split("").each do |cc|
      temp2["0"] << cc
    end


    a_position = temp2["7"] - temp2["1"]
    b_position = temp2["9"] - temp2["3"]
    c_position = temp2["9"] - temp2["5"]
    d_position = temp2["8"] - temp2["0"]
    e_position = temp2["6"] - temp2["5"]
    f_position = temp2["1"] - c_position
    g_position = temp2["3"] - temp2["7"]- d_position

    @_alternate_configuration = {
      a_position.first => "0",
      b_position.first => "1",
      c_position.first => "2",
      d_position.first => "3",
      e_position.first => "4",
      f_position.first => "5",
      g_position.first => "6",
    }
  end
end

result = 0
input.split("\n").each do |entry_raw|
  result += Entry.new(entry_raw).calculate_ouput
end

puts "Result : #{result}"
