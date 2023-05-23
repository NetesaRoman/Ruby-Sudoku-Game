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

    solve_sudoku

    end



private

  def solve_sudoku
    find_empty_cell = find_empty
    return true unless find_empty_cell

    row, col = find_empty_cell

    (1..9).each do |num|
      if valid_move?(row, col, num)
        @auto_board[row][col] = num

        if solve_sudoku
          return true
        else
          @auto_board[row][col] = 0
        end
      end
    end

    false
  end

  def valid_move?(row, col, num)
    !row_contains_num?(row, num) &&
      !col_contains_num?(col, num) &&
      !box_contains_num?(row - (row % 3), col - (col % 3), num)
  end

  def row_contains_num?(row, num)
    @auto_board[row].include?(num)
  end

  def col_contains_num?(col, num)
    @auto_board.any? { |row| row[col] == num }
  end

  def box_contains_num?(start_row, start_col, num)
    (0..2).each do |row|
      (0..2).each do |col|
        if @auto_board[row + start_row][col + start_col] == num
          return true
        end
      end
    end

    false
  end

  def find_empty
    (0..8).each do |row|
      (0..8).each do |col|
        return [row, col] if @auto_board[row][col] == 0
      end
    end

    nil
  end


end


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


