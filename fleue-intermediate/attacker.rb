module Attacker
  def attack_slime
    transition(:fight)
    if @warrior.health <  3
      reconsider
    elsif can_hear?(:ticking?)
      plough_to_bomb
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
    # TODO: initial_captives is void as soon as warrior moves.
    if @initial_captives.map{|s| @warrior.direction_of(s)}.include? dir
      @warrior.rescue! dir
    else
      @warrior.attack! dir
    end
  end

  def plough_to_bomb
    to_bomb = direction_of_all(:ticking?).first
    flankers= @directions.select{|d| @warrior.feel(d).enemy?}.reject{|d| d == to_bomb}
    if not flankers.empty?
      @warrior.bind! flankers.first
    elsif @warrior.feel(to_bomb).empty?
      if distance_of_all(:captive?).sort.reverse.take(2).all?{|s| s == 3}
        if @warrior.health < 5
          @warrior.rest!
        elsif distance_of_all(:enemy?).all?{|d| d >= 3}
          free_ticking_captives
        else
          @warrior.detonate! to_bomb
        end
      else
        free_ticking_captives
      end
    elsif look(to_bomb).take(2).all?{|s| s.enemy?}
      @warrior.detonate! to_bomb
    else
      @warrior.attack! to_bomb
    end
  end
end
