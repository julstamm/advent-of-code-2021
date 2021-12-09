require 'byebug'

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

# input = File.read("input.txt")

input = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"

class Entry
  attr_accessor :signal_patterns, :output_characters

  INITIAL_CONFIGURATION = {
    "a" => "0",
    "b" => "1",
    "c" => "2",
    "d" => "3",
    "e" => "4",
    "f" => "5",
    "g" => "6",
  }

  CHARACTER_DICTIONNARY = {
    "abcefg" => 0,
    "cf" => 1,
    "acdeg" => 2,
    "acdfg" => 3,
    "bcdf" => 4,
    "abdfg" => 5,
    "abdefg" => 6,
    "acf" => 7,
    "abcdefg" => 8,
    "abcdfg" => 9
  }

  # a:  7,8
  # e:  8
  # g:  8
  # b:  4,8
  # d:  4,8
  # c:  1,4,7,8
  # f:  1,4,7,8

  def initialize(signal_patterns, output_characters)
    @signal_patterns = signal_patterns
    @output_characters = output_characters
  end

  def translate(character_to_translate)
    alternate_configuration = calculate_alternate_configuration
    final_led_zone = alternate_configuration[character_to_translate]
    INITIAL_CONFIGURATION.select {|_, value| value == final_led_zone }.first[0]
  end

  def calculate_ouput
    result = ""
    @output_characters.each do |oc|
      display_characters_array = []
      oc.split("").each do |character_to_translate|
        display_characters_array << translate(character_to_translate)
      end

      CHARACTER_DICTIONNARY.select{|k| k.length == display_characters_array.length }.each do |cd|
        definition_array = cd[0].split("")
        if (display_characters_array & definition_array).length == definition_array.length
          result << cd[1].to_s
          break
        end
      end

    end

    result.to_i
  end

  private

  def calculate_alternate_configuration
    # relative_positions = [
    #   [0,2,3,5,6,7,8,9],    # a
    #   [0,4,5,6,8,9],        # b
    #   [0,1,2,3,4,7,8,9],    # c
    #   [2,3,4,5,6,8,9],      # d
    #   [0,2,6,8],            # e
    #   [0,1,3,4,5,6,7,8,9],  # f
    #   [0,2,3,5,6,8,9]       # g
    # ]

    # @signal_patterns = ["acedgfb", "cdfbe", "gcdfa", "fbcad", "dab", "cefabd", "cdfgeb", "eafb", "cagedb", "ab"]
    # @output_characters = ["cdfeb", "fcadb", "cdfeb", "cdbaf"]

    # nb_of_segments = {
    #   2 => [1],
    #   3 => [7],
    #   4 => [4],
    #   5 => [2,3,5],
    #   6 => [0,6,9],
    #   7 => [8]
    # }

    result = {}
    temp = {
      "a" => [],
      "b" => [],
      "c" => [],
      "d" => [],
      "e" => [],
      "f" => [],
      "g" => [],
    }

    @signal_patterns.each do |sp|
      if sp.length == 2
        sp.split("").each do |cc|
          temp[cc] << 1
        end
      end

      if sp.length == 3
        sp.split("").each do |cc|
          temp[cc] << 7
        end
      end

      if sp.length == 4
        sp.split("").each do |cc|
          temp[cc] << 4
        end
      end

      if sp.length == 7
        sp.split("").each do |cc|
          temp[cc] << 8
        end
      end
    end

    # Test for 'a'
    x = temp.select{|k,v| v.sort == [7,8] }.first&.first
    if x
      result[x] = INITIAL_CONFIGURATION["a"]
      temp[x] += [0,2,3,5,6,9]
    end
    
    result.merge({
      "a" => "2",
      "b" => "5",
      "c" => "6",
      # "d" => "0",
      "e" => "1",
      "f" => "3",
      "g" => "4",
    })
  end
end

result = 0
input.split("\n").each do |entry|
  signal_patterns_raw, output_characters_raw = entry.split("|").map(&:strip)
  signal_patterns = signal_patterns_raw.split(" ")
  output_characters = output_characters_raw.split(" ")
  result += Entry.new(signal_patterns, output_characters).calculate_ouput
end

# raise unless result == 61229
puts "YEAH" if result == 5353