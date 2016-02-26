module Moves 
  # Moves warrior away from enemies
  def retreat
    transition(:heal)
    @warrior.walk! @directions.detect{|d| @warrior.feel(d).empty? }
  end

  def move_to_exit
    @warrior.walk! @warrior.direction_of_stairs
    transition(:normal)
  end
end
