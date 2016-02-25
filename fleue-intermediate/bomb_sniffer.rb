# Including this module gives a warrior the ability to rescue captives
module BombSniffer
   def free_ticking_captives
    transition(:ticking)
    if @captives.any?{|d| @warrior.feel(d).ticking?}
      @warrior.rescue! @captives.detect{|d| @warrior.feel(d).ticking?}
    elsif !@d_captives.any?{|d| d.ticking?}
      transition(:normal)
    else
      to_dir = @directions.shuffle.detect{|s| s != opposite(@last_dir) && @warrior.feel(s).empty?}
      @warrior.walk! to_dir
      @last_dir = to_dir
    end
  end
end
