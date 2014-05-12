class InjuryOutcome < ActiveRecord::Base
  def self.create_for(person, injury, kill)
    InjuryOutcome.create(person_id: person.id, injury_id: injury.id, kill: kill)
  end

  def self.for(person, injury)
    return if person.nil? or injury.nil?
    injury_outcome = InjuryOutcome.where(person_id: person.id, injury_id: injury.id).first
    return nil unless injury_outcome
    injury_outcome.kill?
  end
end
