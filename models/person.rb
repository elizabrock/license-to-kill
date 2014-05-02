class Person
  attr_reader :errors
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def self.all
    statement = "Select * from people;"
    execute_and_instantiate(statement)
  end

  def self.count
    statement = "Select count(*) from people;"
    result = Environment.database_connection.execute(statement)
    result[0][0]
  end

  def self.find_by_name(name)
    statement = "Select * from people where name = ?;"
    execute_and_instantiate(statement, name)[0]
  end

  def self.last
    statement = "Select * from people order by id DESC limit(1);"
    execute_and_instantiate(statement)[0]
  end

  def id
    # Temporary, so that we can wrap up the join model during class time:
    5
  end

  def save
    if self.valid?
      statement = "Insert into people (name) values (?);"
      Environment.database_connection.execute(statement, name)
      true
    else
      false
    end
  end

  def valid?
    @errors = []
    if !name.match /[a-zA-Z]/
      @errors << "'#{self.name}' is not a valid person name, as it does not include any letters."
    end
    if Person.find_by_name(self.name)
      @errors << "#{self.name} already exists."
    end
    @errors.empty?
  end

  private

  def self.execute_and_instantiate(statement, bind_vars = [])
    rows = Environment.database_connection.execute(statement, bind_vars)
    results = []
    rows.each do |row|
      results << Person.new(row["name"])
    end
    results
  end
end
