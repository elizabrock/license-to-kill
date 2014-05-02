require_relative '../spec_helper'

describe "Entering desired injury outcomes" do
  context "with valid input" do
    before do
      Injury.create("Decapitation")
      Injury.create("Systemic Marker Poisoning")
      Injury.create("Gut Wound")
    end
    let!(:output){ run_ltk_with_input("1", "Joe", "1", "1", "2") }
    it "should prompt the user for each injury" do
      output.should include_in_order("What if Decapitation?",
                                     "We'll kill you if you suffer from Decapitation",
                                     "What if Systemic Marker Poisoning?",
                                     "We'll kill you if you suffer from Systemic Marker Poisoning",
                                     "What if Gut Wound?",
                                     "We'll let you linger on if you suffer from Gut Wound",
                                    )
    end
    it { InjuryOutcome.for("Joe", "Decapitation").kill?.should be_true }
    it { InjuryOutcome.for("Joe", "Systemic Marker Poisoning").kill?.should be_true }
    it { InjuryOutcome.for("Joe", "Gut Wound").kill?.should be_false }
  end
  context "if there are no injuries" do
    it "should do something"
  end
  context "with invalid input" do
    it "should print a message"
    it "should allow them to continue"
  end
end
