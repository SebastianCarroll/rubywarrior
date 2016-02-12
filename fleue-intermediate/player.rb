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
    gather_information
    act
  end

  def gather_information
    @friendly_captives ||= @directions.select{|d| @warrior.feel(d).captive?}
    @enemies = @directions.select{|d| @warrior.feel(d).enemy?}
    @captives = @directions.select{|d| @warrior.feel(d).captive?}
  end

  def act
    case @state
    when :normal
      act_normal
    when :fight
      attack_slime
    when :bind
      bind_slimes
    when :free
      # Help those bros
    when :heal
      rest_till_healed
    else
      puts @state
    end
  end

  def act_normal
    if @enemies.empty?
      if @friendly_captives.empty?
        if @captives.empty?
          move_to_exit
        else
          attack_slime
        end
      else
        free_captive
      end
    else
      @warrior.bind! @enemies.pop
    end
  end

  def free_captive
    @warrior.rescue! @friendly_captives.pop
  end

  def attack_slime
    transition(:fight)
    if @enemies.empty? && @warrior.health < 7
      rest
    elsif !@enemies.empty?
      @warrior.attack! @enemies.pop
    elsif ! @captives.empty?
      @warrior.attack! @captives.pop
    else
      move_to_exit
    end
  end

  def rest_till_healed
    if @warrior.health <= 18
      rest
    else
      attack_slime
    end
  end

  def rest
    @warrior.rest!
    transition(:heal)
  end

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
    @warrior.walk! @warrior.direction_of_stairs
    transition(:normal)
  end

  def bind_slimes
    enemies = @directions.select{|d| @warrior.feel(d).enemy?}
    captives = @directions.select{|d| @warrior.feel(d).captive?}
    if enemies.empty?
      if @friendly_captives.empty?
        transtition(:free)
      elsif captives.empty?
        transition(:normal)
      else
      end
    else
      @warrior.bind! enemies.pop
    end
  end

  # Transition to the new state and restart the decision logic
  def transition(state)
    @state = state
  end
end
