module Rescuer
  def free_captives
    transition(:free)
    if adjacent_to?(:enemy?)
      if can_hear?(:ticking?)
        move_to_bomber
      else
        attack_slime
      end
    elsif adjacent_to?(:captive?)
      free_captive
    elsif can_hear?(:captive?)
      move_to_captive
    else
      move_to_exit
    end
  end

  def free_captive
    @warrior.rescue! @captives.first
  end

  def move_to_captive
    dir = @warrior.direction_of(@d_captives.pop)
    avoid_if(dir, :stairs?)
  end

  # Avoid dir if test passes on that direction
  def avoid_if(dir, test)
    free_spots = @directions.select{|d| @warrior.feel(d).empty?}

    to_walk = 
      if free_spots.include?(dir) && !@warrior.feel(dir).send(test)
        dir
      else
        free_spots.delete(dir)
        free_spots.first
      end

    @warrior.walk! to_walk
  end
end
