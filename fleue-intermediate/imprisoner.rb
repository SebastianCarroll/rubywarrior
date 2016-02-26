module Imprisoner
  def bind_slimes
    enemies = @directions.select{|d| @warrior.feel(d).enemy?}
    captives = @directions.select{|d| @warrior.feel(d).captive?}
    if adjacent_to?(:enemy?)
      bind_enemy
    else
      if adjacent_to?(:captive?)
        free_captives
      else
        move_to_exit
      end
    end
  end

    def bind_enemy
      @warrior.bind! @enemies.pop
    end
end
