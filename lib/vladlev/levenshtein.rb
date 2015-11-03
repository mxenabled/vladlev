module Vladlev
  class Levenshtein
    def self.distance(str1, str2, maximum_allowable_distance = 9999)
      shortest_string = (str1.size > str2.size) ? str1 : str2
      longest_string = (str1.size > str2.size) ? str2 : str1
      broke_max = false

      if longest_string == shortest_string
        return 0
      elsif longest_string.size - shortest_string.size > maximum_allowable_distance
        return shortest_string.size
      elsif longest_string.size == 0 || shortest_string.size == 0
        return shortest_string.size
      end

      calculation_grid = Array.new(longest_string.size)
      working_grid = Array.new(longest_string.size)

      longest_string.size.times { |position| calculation_grid[position] = position }

      (1...shortest_string.size).each do |i|
        row_minimum = working_grid[0] = calculation_grid[0] + 1
        
        (1...longest_string.size).each do |j|
          cost = (longest_string[j - 1] == shortest_string[i - 1]) ? 0 : 1
          working_grid[j] = [calculation_grid[j] + 1, working_grid[j - 1] + 1, calculation_grid[j - 1] + cost].min
          row_minimum = (working_grid[j] < row_minimum) ? working_grid[j] : row_minimum
        end

        if row_minimum > maximum_allowable_distance
          broke_max = true
          break
        end

        temp_grid = working_grid
        working_grid = calculation_grid
        calculation_grid = temp_grid
      end

      return broke_max ? shortest_string.size : calculation_grid[longest_string.size - 1]
    end
  end
end
