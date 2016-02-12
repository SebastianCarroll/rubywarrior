require 'pry'
require 'pry-nav'

class Player
  def initialize
    @directions = [:forward, :backward, :left, :right]
    @healing = false
    # States:
    #   normal: Walk towards the stairs
    #   fight: Attack slimes/bound slimes
    #   free: Release captives
    #   heal: Move to safe place and rest till full health
    @state = :normal
  end
  def play_turn(warrior)
    @warrior = warrior
    @friendly_captives ||= @directions.select{|d| @warrior.feel(d).captive?}
    act
  end

  def act
    p "In state: #{@state}"
    case @state
    when :normal
      # do normal stuff
      # What if this isn't the right state? How do I transition and then act in one movement? In level 3 I start in :normal state but want to immediately bind a slime. I have the decision extracted to a method so can recurse here? Seems like i could get myself in a mess as I can only act once per turn. I don't see any other way to do it without duplicating logic.


      move_to_exit
    when :fight
      # Attack things
      puts @state
      defeat_slimes
    when :free
      # Help those bros
      puts @state
    when :heal
      # Better check yo self
      puts @state
    else
      puts @state
    end

    enemies = @directions.select{|d| @warrior.feel(d).enemy?}
  end


    # TODO: This decision tree is getting complex. How to break it down into more simple objects? Could use a state machine but not sure exactly how that would work or if it would even give me what i want.
    #if enemies.empty?
    #  if @friendly_captives.empty?
    #    # Kill other captives
    #    captives = @directions.select{|d| @warrior.feel(d).captive?}
    #    if captives.empty?
    #      puts @state
    #      # Normal state
    #    else
    #      puts @state
    #      # kill captives state
    #    end
    #  else
    #    # Free actual captives
    #    puts @state
    #  end
#
#      if @healing
#        if @warrior.health == 20
#          # Fully healed
#          @healing = false
#        else
#          # Still healing and safe to do so
#          @warrior.rest!
#        end
#      else
#        # Fully healed and no monstors so look for exit
#        @warrior.walk! @warrior.direction_of_stairs
#      end
#    else
#      if @warrior.health < 5
#        @healing = true
#        retreat(enemies)
#      else
#        @warrior.bind! enemies.pop
#      end
#    end
#  end

  # Moves warrior away from enemies
  def retreat(enemies)
    safety = @directions.select{|d| @warrior.feel(d).empty? }
    if safety.empty?
      @warrior.rest!
    else
      @warrior.walk! safety.pop
    end
  end

  def move_to_exit
    enemies = @directions.select{|d| @warrior.feel(d).enemy?}
    if enemies.empty?
      @warrior.walk! @warrior.direction_of_stairs
    else
      transition(:fight) 
    end
  end

  def defeat_slimes
    enemies = @directions.select{|d| @warrior.feel(d).enemy?}
    if enemies.empty?
      transition(:normal)
    else
      @warrior.bind! enemies.pop
    end

  end

  # Transition to the new state and restart the decision logic
  def transition(state)
    @state = state
    act
  end
end
