require_relative '../spec_helper'

describe InjuryOutcome do
  context "#create_for" do
    let(:result){ Environment.database_connection.execute("Select * from injury_outcomes") }
    let(:person){ Person.new("Bob") }
    let(:injury){ Injury.new("Stubbed Toe") }
    before do
      person.save
      injury.save
      InjuryOutcome.create_for(person, injury, true)
    end
    it "should save a new injury_outcome to the database" do
      result.count.should == 1
    end
    it "should save the foreign key for person" do
      result[0]["person_id"].should == person.id
    end
    it "should save the foreign key for injury" do
      result[0]["injury_id"].should == injury.id
    end
    it "should have the correct outcome" do
      result[0]["kill"].should == 1
    end
  end
end
