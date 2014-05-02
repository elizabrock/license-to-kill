require_relative '../spec_helper'

describe Person do
  context ".all" do
    context "with no people in the database" do
      it "should return an empty array" do
        Person.all.should == []
      end
    end
    context "with multiple people in the database" do
      before do
        Person.new("Foo").save
        Person.new("Bar").save
        Person.new("Baz").save
        Person.new("Grille").save
      end
      it "should return all of the people" do
        names = Person.all.map(&:name)
        names.should == ["Foo", "Bar", "Baz", "Grille"]
      end
    end
  end

  context ".count" do
    context "with no people in the database" do
      it "should return 0" do
        Person.count.should == 0
      end
    end
    context "with multiple people in the database" do
      before do
        Person.new("Foo").save
        Person.new("Bar").save
        Person.new("Baz").save
        Person.new("Grille").save
      end
      it "should return the correct count" do
        Person.count.should == 4
      end
    end
  end

  context ".find_by_name" do
    context "with no people in the database" do
      it "should return 0" do
        Person.find_by_name("Foo").should be_nil
      end
    end
    context "with person by that name in the database" do
      before do
        Person.new("Foo").save
        Person.new("Bar").save
        Person.new("Baz").save
        Person.new("Grille").save
      end
      it "should return the person with that name" do
        Person.find_by_name("Foo").name.should == "Foo"
      end
    end
  end

  context ".last" do
    context "with no people in the database" do
      it "should return nil" do
        Person.last.should be_nil
      end
    end
    context "with multiple people in the database" do
      before do
        Person.new("Foo").save
        Person.new("Bar").save
        Person.new("Baz").save
        Person.new("Grille").save
      end
      it "should return the last one inserted" do
        Person.last.name.should == "Grille"
      end
    end
  end

  context "#new" do
    let(:person){ Person.new("Bob") }
    it "should store the name" do
      person.name.should == "Bob"
    end
  end

  context "#save" do
    let(:result){ Environment.database_connection.execute("Select name from people") }
    let(:person){ Person.new("foo") }
    context "with a valid person" do
      before do
        person.stub(:valid?){ true }
      end
      it "should only save one row to the database" do
        person.save
        result.count.should == 1
      end
      it "should actually save it to the database" do
        person.save
        result[0]["name"].should == "foo"
      end
    end
    context "with an invalid person" do
      before do
        person.stub(:valid?){ false }
      end
      it "should not save a new person" do
        person.save
        result.count.should == 0
      end
    end
  end

  context "#valid?" do
    let(:result){ Environment.database_connection.execute("Select name from people") }
    context "after fixing the errors" do
      let(:person){ Person.new("123") }
      it "should return true" do
        person.valid?.should be_false
        person.name = "Bob"
        person.valid?.should be_true
      end
    end
    context "with a unique name" do
      let(:person){ Person.new("Joe") }
      it "should return true" do
        person.valid?.should be_true
      end
    end
    context "with a invalid name" do
      let(:person){ Person.new("420") }
      it "should return false" do
        person.valid?.should be_false
      end
      it "should save the error messages" do
        person.valid?
        person.errors.first.should == "'420' is not a valid person name, as it does not include any letters."
      end
    end
    context "with a duplicate name" do
      let(:name){ "Susan" }
      let(:person){ Person.new(name) }
      before do
        Person.new(name).save
      end
      it "should return false" do
        person.valid?.should be_false
      end
      it "should save the error messages" do
        person.valid?
        person.errors.first.should == "#{name} already exists."
      end
    end
  end
end

