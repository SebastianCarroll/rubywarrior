module Attacker
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
      if @enemies.length > 1
        @warrior.bind! @enemies.pop
      else
        @warrior.attack! @enemies.pop
      end
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
end
