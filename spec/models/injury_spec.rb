require_relative '../spec_helper'

describe Injury do
  context ".all" do
    context "with no injuries in the database" do
      it "should return an empty array" do
        Injury.all.should == []
      end
    end
    context "with multiple injuries in the database" do
      let(:foo){ Injury.new("Foo") }
      let(:bar){ Injury.new("Bar") }
      let(:baz){ Injury.new("Baz") }
      let(:grille){ Injury.new("Grille") }
      before do
        foo.save
        bar.save
        baz.save
        grille.save
      end
      it "should return all of the injuries with their names and ids" do
        injury_attrs = Injury.all.map{ |injury| [injury.name,injury.id] }
        injury_attrs.should == [["Foo", foo.id],
                                ["Bar", bar.id],
                                ["Baz", baz.id],
                                ["Grille", grille.id]]
      end
    end
  end

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

  context ".find_by_name" do
    context "with no injuries in the database" do
      it "should return 0" do
        Injury.find_by_name("Foo").should be_nil
      end
    end
    context "with injury by that name in the database" do
      let(:foo){ Injury.new("Foo") }
      before do
        foo.save
        Injury.new("Bar").save
        Injury.new("Baz").save
        Injury.new("Grille").save
      end
      it "should return the injury with that name" do
        Injury.find_by_name("Foo").name.should == "Foo"
      end
      it "should populate the id" do
        Injury.find_by_name("Foo").id.should == foo.id
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
      let(:grille){ Injury.new("Grille") }
      before do
        Injury.new("Foo").save
        Injury.new("Bar").save
        Injury.new("Baz").save
        grille.save
      end
      it "should return the last one inserted" do
        Injury.last.name.should == "Grille"
      end
      it "should return the last one inserted with id populated" do
        Injury.last.id.should == grille.id
      end
    end
  end

  context "#new" do
    let(:injury){ Injury.new("impalement, 1/2 inch diameter or smaller") }
    it "should store the name" do
      injury.name.should == "impalement, 1/2 inch diameter or smaller"
    end
  end

  context "#create" do
    let(:result){ Environment.database_connection.execute("Select * from injuries") }
    let(:injury){ Injury.create("foo") }
    context "with a valid injury" do
      before do
        Injury.any_instance.stub(:valid?){ true }
        injury
      end
      it "should record the new id" do
        result[0]["id"].should == injury.id
      end
      it "should only save one row to the database" do
        result.count.should == 1
      end
      it "should actually save it to the database" do
        result[0]["name"].should == "foo"
      end
    end
    context "with an invalid injury" do
      before do
        Injury.any_instance.stub(:valid?){ false }
        injury
      end
      it "should not save a new injury" do
        result.count.should == 0
      end
    end
  end

  context "#save" do
    let(:result){ Environment.database_connection.execute("Select * from injuries") }
    let(:injury){ Injury.new("foo") }
    context "with a valid injury" do
      before do
        injury.stub(:valid?){ true }
      end
      it "should only save one row to the database" do
        injury.save
        result.count.should == 1
      end
      it "should record the new id" do
        injury.save
        injury.id.should == result[0]["id"]
      end
      it "should actually save it to the database" do
        injury.save
        result[0]["name"].should == "foo"
      end
    end
    context "with an invalid injury" do
      before do
        injury.stub(:valid?){ false }
      end
      it "should not save a new injury" do
        injury.save
        result.count.should == 0
      end
    end
  end

  context "#valid?" do
    let(:result){ Environment.database_connection.execute("Select name from injuries") }
    context "after fixing the errors" do
      let(:injury){ Injury.new("123") }
      it "should return true" do
        injury.valid?.should be_false
        injury.name = "Bob"
        injury.valid?.should be_true
      end
    end
    context "with a unique name" do
      let(:injury){ Injury.new("impalement, 1/2 - 2 inches diameter") }
      it "should return true" do
        injury.valid?.should be_true
      end
    end
    context "with a invalid name" do
      let(:injury){ Injury.new("420") }
      it "should return false" do
        injury.valid?.should be_false
      end
      it "should save the error messages" do
        injury.valid?
        injury.errors.first.should == "'420' is not a valid injury name, as it does not include any letters."
      end
    end
    context "with a duplicate name" do
      let(:injury){ Injury.new("impalement, 1/2 inch diameter or smaller") }
      before do
        Injury.new("impalement, 1/2 inch diameter or smaller").save
      end
      it "should return false" do
        injury.valid?.should be_false
      end
      it "should save the error messages" do
        injury.valid?
        injury.errors.first.should == "impalement, 1/2 inch diameter or smaller already exists."
      end
    end
  end
end
