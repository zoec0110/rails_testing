def leap_year?(y)
  (y % 400).zero? || ((y % 4).zero? && y % 100 != 0)
end
