class SudokuController < ApplicationController




  def index
    @board = Array.new(9) { Array.new(9, 0) }
    @auto_board = Array.new(9) { Array.new(9, 0) }
  end


  def submit

    @board = Array.new(9) { Array.new(9, 0) }
    array_params = params.require(:array).permit!
    array_params.to_h.each_with_index do |(row_key, row), i|
      row.each_with_index do |(col_key, col), j|
        @board[i][j] = col.to_i
      end
    end


    if valid_sudoku?(@board)
      flash[:notice] = "Congratulations, you solved the Sudoku puzzle!"
    else
      flash[:alert] = "Sorry, your solution is not correct. Please try again."
    end
  end


  def auto

    @auto_board = Array.new(9) { Array.new(9, 0) }
    array_params = params.require(:array_auto).permit!
    array_params.to_h.each_with_index do |(row_key, row), i|
      row.each_with_index do |(col_key, col), j|
        @auto_board[i][j] = col.to_i
      end
    end


    @auto_board = @auto_board.transpose
    @auto_board.each do |column|
      available_numbers = (1..9).to_a
      column.map! do
        number = available_numbers.sample
        available_numbers.delete(number)
        number
      end
    end
    @auto_board = @auto_board.transpose
    end



private

def valid_sudoku?(board)
  # Check rows
  board.each do |row|
    return false unless row.uniq.size == 9
  end

  # Check columns
  9.times do |j|
    column = board.map { |row| row[j] }
    return false unless column.uniq.size == 9
  end

  # Check squares
  3.times do |i|
    3.times do |j|
      square = []
      3.times do |ii|
        3.times do |jj|
          square << board[i * 3 + ii][j * 3 + jj]
        end
      end
      return false unless square.uniq.size == 9
    end
  end

  true
end
  end

