class Injury < ActiveRecord::Base
  validates :name, uniqueness: { message: "already exists." }
  validates :name, format: { with: /[a-zA-Z]/, message: "is not a valid injury name, as it does not include any letters." }
end
