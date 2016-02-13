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
    @initial_captives ||= @warrior.listen.select{|d| d.captive?}
    @enemies = @directions.select{|d| @warrior.feel(d).enemy?}
    @captives = @directions.select{|d| @warrior.feel(d).captive?}
    @d_enemies, @d_captives = @warrior.listen.partition{|s| s.enemy?}
  end

  def act
    puts @state
    case @state
    when :normal
      act_normal
    when :fight
      attack_slime
    when :bind
      bind_slimes
    when :free
      free_captives
    when :heal
      rest_till_healed
    else
      puts @state
    end
  end

  # TODO: This decision tree is getting pretty complex again
  # Not sure how to simplify it though.
  def act_normal
    if @enemies.empty?
      if @friendly_captives.empty?
        if @captives.empty?
          if !@d_captives.empty?
            free_captives
          elsif !@d_enemies.empty?
            attack_slime
          else
            move_to_exit
          end
        else
          attack_slime
        end
      else
        free_captives
      end
    else
      @warrior.bind! @enemies.pop
    end
  end

  def free_captives
    transition(:free)
    if !@enemies.empty?
      attack_slime
    elsif !@captives.empty?
      free_captive
    elsif !@d_captives.empty?
      dir = @warrior.direction_of(@d_captives.pop)
      @warrior.walk! dir
    end
  end

  def free_captive
    @warrior.rescue! @friendly_captives.pop
  end

  # TODO: Again so many if/else statements
  def attack_slime
    transition(:fight)
    if @warrior.health < 7
      if @enemies.empty?
        rest
      else
        retreat
      end
    elsif !@enemies.empty?
      @warrior.attack! @enemies.pop
    elsif ! @captives.empty?
      dir = @captives.pop
      if @initial_captives.map{|s| @warrior.direction_of(s)}.include? dir
        @warrior.rescue! dir
      else
        @warrior.attack! dir
      end
    elsif !@d_enemies.empty?
      dir = @warrior.direction_of(@d_enemies.first)
      @warrior.walk! dir
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
  def retreat
    transition(:heal)
    @warrior.walk! @directions.detect{|d| @warrior.feel(d).empty? }
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
