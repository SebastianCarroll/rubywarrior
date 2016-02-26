# Including this module gives a warrior the ability to rescue captives
module BombSniffer
  def free_ticking_captives
    transition(:ticking)
    if adjacent_to?(:ticking?)
      free_bomber
    elsif can_hear?(:ticking?)
      move_to_bomber
    else
      act_normal
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
end
