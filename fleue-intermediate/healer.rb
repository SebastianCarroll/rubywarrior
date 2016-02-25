module Healer
  def rest_till_healed
    if @warrior.health <= 18
      rest
    else
      attack_slime
    end
  end

  def rest
    @warrior.rest!
    transition(:heal)
  end


end
