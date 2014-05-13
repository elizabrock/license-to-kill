require_relative '../spec_helper'

describe InjuryOutcome do
  describe "#for" do
    let(:person1){ Person.create(name: "Bob") }
    let(:person2){ Person.create(name: "Julie") }
    let(:injury1){ Injury.create(name: "Stubbed Toe") }
    let(:injury2){ Injury.create(name: "Botched Suicide") }
    before do
      person1.injury_outcomes.create(injury: injury2, kill: false)
      person2.injury_outcomes.create(injury: injury1, kill: true)
      person1.injury_outcomes.create(injury: injury1, kill: true)
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
