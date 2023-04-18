require "test_helper"

class SudokuControllerTest < ActionDispatch::IntegrationTest
  test "should get main" do
    get sudoku_main_url
    assert_response :success
  end

  test "should get submit" do
    get sudoku_submit_url
    assert_response :success
  end
end
