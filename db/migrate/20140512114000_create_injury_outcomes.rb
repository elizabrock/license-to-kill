class CreateInjuryOutcomes < ActiveRecord::Migration
  def change
    create_table :injury_outcomes do |t|
      t.integer :person_id
      t.integer :injury_id
      t.boolean :kill
      t.timestamps
    end
  end
end
