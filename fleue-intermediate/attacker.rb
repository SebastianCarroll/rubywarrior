module Attacker
  # TODO: Again so many if/else statements
  def attack_slime
    transition(:fight)
    if @warrior.health < 7
      if adjacent_to?(:enemy?)
        retreat
      else
        rest
      end
    elsif adjacent_to?(:enemy?)
      if @enemies.length > 1
        @warrior.bind! @enemies.pop
      else
        @warrior.attack! @enemies.pop
      end
    elsif adjacent_to?(:captive?)
      dir = @captives.pop
      if @initial_captives.map{|s| @warrior.direction_of(s)}.include? dir
        @warrior.rescue! dir
      else
        @warrior.attack! dir
      end
    elsif can_hear?(:captive?)
      dir = @warrior.direction_of(@d_enemies.first)
      @warrior.walk! dir
    else
      move_to_exit
    end
  end
end
