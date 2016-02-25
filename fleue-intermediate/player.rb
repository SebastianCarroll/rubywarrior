require 'pry'
require 'pry-nav'
require_relative './bomb_sniffer'
require_relative './rescuer'
require_relative './attacker'
require_relative './healer'
require_relative './imprisoner'
require_relative './moves'
require_relative './senses'

class Player
  include BombSniffer
  include Rescuer
  include Attacker
  include Healer
  include Imprisoner

  include Moves
  include Senses

  def initialize
    @directions = [:forward, :backward, :left, :right]
    @healing = false
    @state = :normal
  end

  def play_turn(warrior)
    @warrior = warrior
    gather_information
    act
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
    when :ticking
      free_ticking_captives
    else
      puts @state
    end
  end

  # TODO: This decision tree is getting pretty complex again
  # Not sure how to simplify it though.
  def act_normal
    if adjacent_to?(:enemy?)
      @warrior.bind! @enemies.pop
    elsif @d_captives.any?{|d| d.ticking?}
      free_ticking_captives
    else
      if !@friendly_captives.empty?
        free_captives
      else
        if adjacent_to?(:captive?)
          attack_slime
        else
          if !@d_captives.empty?
            free_captives
          elsif !@d_enemies.empty?
            attack_slime
          else
            move_to_exit
          end
        end
      end
    end
  end

  def opposite(dir)
    dirs = {forward: :backward,
            backward: :forward,
            left: :right,
            right: :left,}
    dirs[dir]
  end

  # Transition to the new state and restart the decision logic
  def transition(state)
    @state = state
  end
end
