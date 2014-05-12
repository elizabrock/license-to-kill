require_relative '../spec_helper'

describe InjuryOutcome do
  context "#create_for" do
    let(:result){ InjuryOutcome.connection.execute("Select * from injury_outcomes") }
    let(:person){ Person.new(name: "Bob") }
    let(:injury){ Injury.new(name: "Stubbed Toe") }
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
      result[0]["kill"].should == 't'
    end
  end

  describe "#for" do
    let(:person1){ Person.create(name: "Bob") }
    let(:person2){ Person.create(name: "Julie") }
    let(:injury1){ Injury.create(name: "Stubbed Toe") }
    let(:injury2){ Injury.create(name: "Botched Suicide") }
    before do
      InjuryOutcome.create_for(person1, injury2, false)
      InjuryOutcome.create_for(person2, injury1, true)
      InjuryOutcome.create_for(person1, injury1, true)
    end
    context "if injury is nil" do
      let(:result){ InjuryOutcome.for(person1, nil) }
      it { result.should be_nil }
    end
    context "if person is nil" do
      let(:result){ InjuryOutcome.for(nil, injury1) }
      it { result.should be_nil }
    end
    context "if the person and injury don't correspond" do
      let(:result){ InjuryOutcome.for(person2, injury2) }
      it { result.should be_nil }
    end
    context "if there is a matching injury outcome that wants death" do
      let(:result){ InjuryOutcome.for(person1, injury1) }
      it { result.should == true }
    end
    context "if there is a matching injury outcome that doesn't want death" do
      let(:result){ InjuryOutcome.for(person1, injury2) }
      it { result.should == false }
    end
  end
end
