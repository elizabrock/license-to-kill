require_relative '../spec_helper'

describe "Adding a person" do
  before do
    person = Person.new("Jane")
    person.save
  end
  context "adding a unique person" do
    let!(:output){ run_ltk_with_input("1", "Joe") }
    it "should print a confirmation message" do
      output.should include("Joe has been added.")
      Person.count.should == 2
    end
    it "should insert a new person" do
      Person.count.should == 2
    end
    it "should use the name we entered" do
      Person.last.name.should == "Joe"
    end
  end
  context "adding a duplicate person" do
    let(:output){ run_ltk_with_input("1", "Jane") }
    it "should print an error message" do
      output.should include("Jane already exists.")
    end
    it "should ask them to try again" do
      menu_text = "Who do you want to add?"
      output.should include_in_order(menu_text, "already exists", menu_text)
    end
    it "shouldn't save the duplicate" do
      Person.count.should == 1
    end
    context "and trying again" do
      let!(:output){ run_ltk_with_input("1", "Jane", "Sandy") }
      it "should save a unique item" do
        Person.last.name.should == "Sandy"
      end
      it "should print a success message at the end" do
        output.should include("Sandy has been added")
      end
    end
  end
  context "entering an invalid looking person name" do
    context "with SQL injection" do
      let(:input){ "phalangectomy'), ('425" }
      let!(:output){ run_ltk_with_input("1", input) }
      it "should create the person without evaluating the SQL" do
        Person.last.name.should == input
      end
      it "shouldn't create an extra person" do
        Person.count.should == 2
      end
      it "should print a success message at the end" do
        output.should include("#{input} has been added")
      end
    end
    context "without alphabet characters" do
      let(:output){ run_ltk_with_input("1", "4*25") }
      it "should not save the person" do
        Person.count.should == 1
      end
      it "should print an error message" do
        output.should include("'4*25' is not a valid person name, as it does not include any letters.")
      end
      it "should let them try again" do
        menu_text = "Who do you want to add?"
        output.should include_in_order(menu_text, "not a valid", menu_text)
      end
    end
  end
end

