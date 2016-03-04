module Healer
  def rest_till_healed
    limit = can_hear?(:ticking?) ? 2 : 18
    if @warrior.health <= limit
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
