module Senses
  def gather_information
    @friendly_captives ||= @directions.select{|d| @warrior.feel(d).captive?}
    @initial_captives ||= @warrior.listen.select{|d| d.captive?}
    @enemies = @directions.select{|d| @warrior.feel(d).enemy?}
    @captives = @directions.select{|d| @warrior.feel(d).captive?}
    @d_enemies, @d_captives = @warrior.listen.partition{|s| s.enemy?}
  end

  def adjacent_to?(method)
    @directions.any?{|d| @warrior.feel(d).send(method)}
  end

  def can_hear?(method)
    @warrior.listen.any?{|square| square.send(method)}
  end

  def outnumbered?
    @directions.count{|d| @warrior.feel(d).enemy?} > 1
  end
end
