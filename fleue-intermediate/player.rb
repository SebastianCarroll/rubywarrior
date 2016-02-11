require 'pry'
require 'pry-nav'

class Player
  def initialize
    @directions = [:forward, :backward, :left, :right]
    @healing = false
  end
  def play_turn(warrior)
    @friendly_captives ||= @directions.select{|d| warrior.feel(d).captive?}
    enemies = @directions.select do |d| 
      (warrior.feel(d).enemy?)
    end

    # TODO: This decision tree is getting complex. How to break it down into more simple objects? Could use a state machine but not sure exactly how that would work or if it would even give me what i want.
    if enemies.empty?
      if @friendly_captives.empty?
        # Kill other captives
        captives = @directions.select{|d| warrior.feel(d).captive?}
        if captives.empty?
          # Normal state
        else
          # kill captives state
        end
      else
        # Free actual captives
        warrior.free! @friendly_captives.pop unless 
      end

      if @healing
        if warrior.health == 20
          # Fully healed
          @healing = false
        else
          # Still healing and safe to do so
          warrior.rest!
        end
      else
        # Fully healed and no monstors so look for exit
        warrior.walk! warrior.direction_of_stairs
      end
    else
      if warrior.health < 5
        @healing = true
        retreat(warrior, enemies)
      else
        warrior.bind! enemies.pop
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
