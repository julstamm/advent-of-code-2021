file = File.read("input.txt").split("\n")

input = []
File.readlines("input.txt").each do |line|
  input << line
end

bin_gamma_rate = ""

(0..11).each do |index|
  zeros = ones = 0
  input.each do |number|
    x = number.slice(index).to_i
    if x == 0
      zeros += 1
    else
      ones += 1
    end
  end

  if zeros > ones
    bin_gamma_rate << "0"
  else
    bin_gamma_rate << "1"
  end
end

def int_complement(str_binary)
  result = []
  str_binary.split("").map(&:to_i).each do |el|
      el == 0 ? result << 1 : result << 0
  end
  return result.join
end

gamma_rate = bin_gamma_rate.to_i(2)
epsilon_rate = int_complement(bin_gamma_rate).to_i(2)
power_consumption = gamma_rate * epsilon_rate

puts "Result 1 : #{gamma_rate * epsilon_rate}"

oxygen_generator_rating = input
co2_scrubber_rating = input
oxygen_result = nil
co2_result = nil

end_index = input[0].length - 1
(0..end_index).each do |current_bit_position|
  zeros = []
  ones = []
  oxygen_generator_rating.each do |number|
    current_value = number.slice(current_bit_position)
    if current_value == "0"
      zeros << number
    else
      ones << number
    end
  end

  if oxygen_result.nil?
    if zeros.length > ones.length
      oxygen_generator_rating = zeros
    elsif zeros.length <= ones.length
      oxygen_generator_rating = ones
    end
    if oxygen_generator_rating.length == 1
      oxygen_result = oxygen_generator_rating[0].to_i(2)
    end
  end

  zeros = []
  ones = []
  co2_scrubber_rating.each do |number|
    current_value = number.slice(current_bit_position)
    if current_value == "0"
      zeros << number
    else
      ones << number
    end
  end

  if co2_result.nil?
    if zeros.length > ones.length
      co2_scrubber_rating = ones
    elsif zeros.length <= ones.length
      co2_scrubber_rating = zeros
    end
    if co2_scrubber_rating.length == 1
      co2_result = co2_scrubber_rating[0].to_i(2)
    end
  end

  break if oxygen_result # && co2_result
end

puts "Result 2 : #{oxygen_result * co2_result}"
