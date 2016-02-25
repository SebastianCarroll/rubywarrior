module Senses
  def gather_information
    @friendly_captives ||= @directions.select{|d| @warrior.feel(d).captive?}
    @initial_captives ||= @warrior.listen.select{|d| d.captive?}
    @enemies = @directions.select{|d| @warrior.feel(d).enemy?}
    @captives = @directions.select{|d| @warrior.feel(d).captive?}
    @d_enemies, @d_captives = @warrior.listen.partition{|s| s.enemy?}
  end

  def adjacent?(method)
    @directions.any?{|d| @warrior.feel(d).send(method)}
  end
end
