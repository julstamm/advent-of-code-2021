require "ostruct"

# input = %{
#   7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
#   22 13 17 11  0
#   8  2 23  4 24
#   21  9 14 16  7
#   6 10  3 18  5
#   1 12 20 15 19

#   3 15  0  2 22
#   9 18 13 17  5
#   19  8  7 25 23
#   20 11 10 24  4
#   14 21 16 12  6

#   14 21 17 24  4
#   10 16 15  9 19
#   18  8 23 26 20
#   22 11 13  6  5
#   2  0 12  3  7
# }

input = File.read("input.txt")

class Number
  attr_accessor :value, :marked

  def initialize(value)
    @value = value
    @marked = false
  end

  def process!(input)
    @marked = true if input == value
  end

  def marked?
    @marked
  end
end

class Row
  attr_accessor :numbers

  def initialize(numbers)
    @numbers = numbers
  end

  def new_draw!(input)
    numbers.each { |n| n.process!(input) }
  end

  def is_winning?
    numbers.all? { |n| n.marked? }
  end

  def sum_of_unmarked_numbers
    numbers.select { |n| n.marked? == false }.sum(&:value)
  end
end

class Column
  def initialize(rows, index)
    @numbers = rows.map {|r| r.numbers[index] }
  end

  def is_winning?
    @numbers.all? { |n| n.marked? }
  end
end

class Board
  attr_accessor :id, :is_winning, :score

  def initialize(rows)
    set_board_id
    @rows = rows.map do |numbers|
      Row.new(
        numbers.map { |n| Number.new(n) }
      )
    end
    @is_winning = false
  end

  def new_draw!(current_draw)
    @rows.each do |r|
      r.new_draw!(current_draw)
    end

    @rows.each do |r|
      if r.is_winning?
        @is_winning = true
        break
      end
    end

    columns.each do |c|
      if c.is_winning?
        @is_winning = true
        break
      end
    end

    @score = current_draw * @rows.sum(&:sum_of_unmarked_numbers)
  end

  def is_winning?
    @is_winning
  end

  private

  def set_board_id
    @@_id ||= 1
    @id = @@_id
    @@_id += 1
  end

  def columns
    (0..BoardCollection::ROW_SIZE - 1).map do |index|
      Column.new(@rows, index)
    end
  end
end

class BoardCollection
  attr_accessor :boards

  ROW_SIZE = 5
  COLUMN_SIZE = 5

  def initialize(input)
    @boards = build_boards(
      input.join(" ").split(" ").map(&:to_i)
    )
  end

  def still_in_game
    @boards.select{|b| b.is_winning == false }
  end

  private

  def build_boards(numbers)
    raw_boards, current_board, current_row = [], [], []
    numbers.each do |n|
      current_row << n
      if current_row.count == ROW_SIZE
        current_board << current_row
        current_row = []
      end

      if current_board.count == COLUMN_SIZE
        raw_boards << current_board
        current_board = []
      end
    end
    raw_boards.map { |b| Board.new(b) }
  end
end

class BingoGame
  def initialize(boards_raw)
    @boards = BoardCollection.new(boards_raw)
  end

  def play(draws_raw)
    draws = draws_raw.split(",").map(&:to_i)
    first_winner = last_winner = nil

    draws.each do |current_draw|
      @boards.still_in_game.each do |board|
        board.new_draw!(current_draw)
        if board.is_winning?
          first_winner = board unless first_winner
          last_winner = board
        end
      end
    end

    OpenStruct.new(
      first_winner: first_winner,
      last_winner: last_winner
    )
  end
end

lines = input.split("\n").reject {|l| l.empty? }
boards_raw = lines[1..]
draws_raw = lines[0]

game = BingoGame.new(boards_raw)
result = game.play(draws_raw)

def print_result(board)
  puts "Board ##{board.id}"
  puts "Score : #{board.score}"
  puts "---------------------------"
end

puts "We have a winner!!"
print_result(result.first_winner) # 44 - 58374
puts "Last winning board:"
print_result(result.last_winner) # 17 - 11377
