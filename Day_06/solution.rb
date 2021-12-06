class LanternfishCensus
  attr_reader :fish_groups, :number_of_day

  DAYS_LEFT_FOR_NEW_FISH = 8
  DAYS_LEFT_FOR_NEW_PARENT = 6

  def initialize(input, number_of_day)
    @fish_groups = input.group_by {|x| x.itself.to_s }.map {|k, v| [k, v.count] }.to_h
    @number_of_day = number_of_day
  end

  def calculate_total
    number_of_day.times { calculate_groups_for_new_day }
    fish_groups.sum{|g| g.last }
  end

  private

  def calculate_groups_for_new_day
    result = { DAYS_LEFT_FOR_NEW_PARENT.to_s => 0 }
    @fish_groups.each do |k, nb_of_fish|
      current_group = k.to_i
      if current_group == 0
        new_fish(result, nb_of_fish)
      else
        decrease_life(result, current_group, nb_of_fish)
      end
    end
    @fish_groups = result
  end

  def new_fish(result, nb_of_fish)
    result[DAYS_LEFT_FOR_NEW_PARENT.to_s] += nb_of_fish
    result[DAYS_LEFT_FOR_NEW_FISH.to_s] = nb_of_fish
  end

  def decrease_life(result, current_group, nb_of_fish)
    if current_group == 7
      result[(current_group - 1).to_s] += nb_of_fish
    else
      result[(current_group - 1).to_s] = nb_of_fish
    end
  end
end

input = [3,4,3,1,2]
input = File.read("input.txt").split(",").map(&:to_i)
number_of_day = 256

result = LanternfishCensus.new(input, number_of_day)

puts "Total after #{number_of_day} day(s): #{result.calculate_total}" # 26984457539 or 1644286074024
