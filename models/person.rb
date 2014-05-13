class Person < ActiveRecord::Base
  validates :name, uniqueness: { message: "already exists." }
  validates :name, format: { with: /[a-zA-Z]/, message: "is not a valid person name, as it does not include any letters." }

  has_many :injury_outcomes
  # If I wanted to find all of the injuries for this person:
  # has_many :injuries, through: :injury_outcomes
end
