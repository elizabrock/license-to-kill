require_relative '../spec_helper'

describe "Entering desired injury outcomes" do
  context "with valid input" do
    let!(:decapitation){ Injury.create("Decapitation") }
    let!(:marker_poisoning){ Injury.create("Systemic Marker Poisoning") }
    let!(:gut_wound){ Injury.create("Gut Wound") }
    let!(:output){ run_ltk_with_input("1", "Joe", "1", "1", "2") }
    let(:joe){ Person.find_by_name("Joe") }
    it "should prompt the user for each injury" do
      output.should include_in_order("What if Decapitation?",
                                     "What if Systemic Marker Poisoning?",
                                     "What if Gut Wound?",
                                    )
    end
    it "should print the menu for response menu for each injury" do
      response_menu = "1. Put me out of my misery.\n2. Just a flesh wound. Carry on."
      output.should include_in_order("What if Decapitation?",
                                     response_menu,
                                     "What if Systemic Marker Poisoning?",
                                     response_menu,
                                     "What if Gut Wound?",
                                     response_menu,
                                    )
    end
    it "should prompt and respond the user for each injury" do
      output.should include_in_order("What if Decapitation?",
                                     "We'll kill you if you suffer from Decapitation",
                                     "What if Systemic Marker Poisoning?",
                                     "We'll kill you if you suffer from Systemic Marker Poisoning",
                                     "What if Gut Wound?",
                                     "We'll let you linger on if you suffer from Gut Wound",
                                    )
    end
    it { InjuryOutcome.for(joe, decapitation).should be_true }
    it { InjuryOutcome.for(joe, marker_poisoning).should be_true }
    it { InjuryOutcome.for(joe, gut_wound).should be_false }
  end
  context "if there are no injuries" do
    it "should do something"
  end
  context "with invalid input" do
    it "should print a message"
    it "should allow them to continue"
  end
end
