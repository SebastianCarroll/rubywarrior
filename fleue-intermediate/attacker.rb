module Attacker
  def attack_slime
    transition(:fight)
    if @warrior.health < 7
      reconsider
    elsif adjacent_to?(:enemy?)
      attack
    elsif adjacent_to?(:captive?)
      deal_with_captive
    elsif can_hear?(:captive?)
      @warrior.walk! @warrior.direction_of(@d_captives.first)
    elsif can_hear?(:enemy?)
      @warrior.walk! @warrior.direction_of(@d_enemies.first)
    else
      move_to_exit
    end
  end

  def reconsider
    if adjacent_to?(:enemy?)
      retreat
    else
      rest
    end
  end

  def attack
    if outnumbered? 
      @warrior.bind! @enemies.pop
    else
      @warrior.attack! @enemies.pop
    end
  end

  def deal_with_captive
    dir = @captives.pop
    if @initial_captives.map{|s| @warrior.direction_of(s)}.include? dir
      @warrior.rescue! dir
    else
      @warrior.attack! dir
    end
  end
end
