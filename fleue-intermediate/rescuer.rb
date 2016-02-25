module Rescuer
  def free_captives
    transition(:free)
    if adjacent_to?(:enemy?)
      if @d_captives.any?{|d| d.ticking?}
        bind_slimes
      else
        attack_slime
      end
    elsif adjacent_to?(:captive?)
      free_captive
    elsif !@d_captives.empty?
      dir = @warrior.direction_of(@d_captives.pop)
      stairs = @warrior.direction_of_stairs
      to_walk = if @warrior.feel(dir).stairs?
                  @directions.shuffle.detect{|s| s != dir && @warrior.feel(s).empty?}
                else
                  dir
                end

      @warrior.walk! to_walk
    else
      move_to_exit
    end
  end

  def free_captive
    @warrior.rescue! @captives.first
  end

end
