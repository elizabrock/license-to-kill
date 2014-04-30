require_relative 'spec_helper'

describe Injury do
  context ".count" do
    context "with no injuries in the database" do
      it "should return 0" do
        Injury.count.should == 0
      end
    end
    context "with multiple injuries in the database" do
      before do
        Injury.new("Foo").save
        Injury.new("Bar").save
        Injury.new("Baz").save
        Injury.new("Grille").save
      end
      it "should return the correct count" do
        Injury.count.should == 4
      end
    end
  end

  context ".last" do
    context "with no injuries in the database" do
      it "should return nil" do
        Injury.last.should be_nil
      end
    end
    context "with multiple injuries in the database" do
      before do
        Injury.new("Foo").save
        Injury.new("Bar").save
        Injury.new("Baz").save
        Injury.new("Grille").save
      end
      it "should return the last one inserted" do
        Injury.last.name.should == "Grille"
      end
    end
  end

  context "#new" do
    let(:injury){ Injury.new("impalement, 1/2 inch diameter or smaller") }
    it "should store the name" do
      injury.name.should == "impalement, 1/2 inch diameter or smaller"
    end
  end

  context "#save" do
    let(:injury){ Injury.new("impalement, 1/2 - 2 inches diameter") }
    let(:result){ Environment.database_connection.execute("Select name from injuries") }
    it "should return true" do
      injury.save.should be_true
    end
    it "should only save one row to the database" do
      injury.save
      result.count.should == 1
    end
    it "should actually save it to the database" do
      injury.save
      result[0]["name"].should == "impalement, 1/2 - 2 inches diameter"
    end
  end
end
