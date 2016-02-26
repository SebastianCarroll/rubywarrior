# Including this module gives a warrior the ability to rescue captives
module BombSniffer
  def free_ticking_captives
    transition(:ticking)
    if adjacent_to?(:ticking?)
      free_bomber
    elsif can_hear?(:ticking?)
      move_to_bomber
    else
      #TODO: Potentially wasted turn here. Can't just walk to exit though. That could waste more turns.
      transition(:normal)
    end
  end

  def free_bomber
    @warrior.rescue! @captives.detect{|d| @warrior.feel(d).ticking?}
  end

  def move_to_bomber
    to_dir = @directions.shuffle.detect{|s| s != opposite(@last_dir) && @warrior.feel(s).empty?}
    @warrior.walk! to_dir
    @last_dir = to_dir
  end

  def free_and_closest_to(method)
    bomber = @warrior.listen.detect{|square| square.send(method)}
    closest_to(@warrior.direction_of(bomber))
  end

  def closest_to(dir)
    if free(dir)
      dir
    else
      sideways = orthogonal(dir).select{|d| free(d)}
      if sideways.length > 1
        sideways.first
      else
        opposite(dir)
      end
    end
  end

  def free(dir)
    @warrior.feel(dir).empty?
  end

  def orthogonal(dir)
    rl = [:right,:left]
    fb = [:forwards, :backwards]
    rl.include?(dir) ? fb : rl
  end
end
