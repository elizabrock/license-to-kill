class InjuryOutcome < ActiveRecord::Base
  belongs_to :injury
  belongs_to :person

  def self.for(person, injury)
    return if person.nil? or injury.nil?
    injury_outcome = InjuryOutcome.where(person_id: person.id, injury_id: injury.id).first
    return nil unless injury_outcome
    injury_outcome.kill?
  end
end
