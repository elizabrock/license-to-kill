class InjuryOutcome < ActiveRecord::Base
  belongs_to :injury
  belongs_to :person

  scope :for, ->(injury){ where(injury: injury) }
end
