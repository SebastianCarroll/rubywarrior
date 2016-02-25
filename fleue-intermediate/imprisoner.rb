module Imprisoner
  def bind_slimes
    enemies = @directions.select{|d| @warrior.feel(d).enemy?}
    captives = @directions.select{|d| @warrior.feel(d).captive?}
    if enemies.empty?
      if @friendly_captives.empty?
        transtition(:free)
      elsif captives.empty?
        #transition(:normal)
        move_to_exit
      else
      end
    else
      @warrior.bind! enemies.pop
    end
  end
end
