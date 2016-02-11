require 'pry'
require 'pry-nav'

class Player
  def initialize
    @directions = [:forward, :backward, :left, :right]
    @healing = false
  end
  def play_turn(warrior)
    enemies = @directions.select{|d| warrior.feel(d).enemy?}

    if enemies.empty? 
      if @healing
        if warrior.health == 20
          @healing = false
        else
          warrior.rest!
        end
      else
        warrior.walk! warrior.direction_of_stairs
      end
    else
      if warrior.health < 5
        @healing = true
        retreat(warrior, enemies)
      else
        warrior.attack! enemies.pop
      end
    end
  end

  # Moves warrior away from enemies
  def retreat(warrior, enemies)
    safety = @directions.select{|d| warrior.feel(d).empty? }
    if safety.empty?
      warrior.rest!
    else
      warrior.walk! safety.pop
    end
  end
end
