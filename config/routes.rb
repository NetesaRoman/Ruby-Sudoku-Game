Rails.application.routes.draw do
  get 'sudoku/index'
  post 'sudoku/auto'
  post 'sudoku/submit'
  root 'sudoku#index'
end
