class Injury
  attr_reader :errors
  attr_reader :id
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def self.all
    statement = "Select * from injuries;"
    execute_and_instantiate(statement)
  end

  def self.count
    statement = "Select count(*) from injuries;"
    result = Environment.database_connection.execute(statement)
    result[0][0]
  end

  def self.create(name)
    injury = Injury.new(name)
    injury.save
    injury
  end

  def self.find_by_name(name)
    statement = "Select * from injuries where name = ?;"
    execute_and_instantiate(statement, name)[0]
  end

  def self.last
    statement = "Select * from injuries order by id DESC limit(1);"
    execute_and_instantiate(statement)[0]
  end

  def save
    if self.valid?
      statement = "Insert into injuries (name) values (?);"
      Environment.database_connection.execute(statement, name)
      @id = Environment.database_connection.execute("SELECT last_insert_rowid();")[0][0]
      true
    else
      false
    end
  end

  def valid?
    @errors = []
    if !name.match /[a-zA-Z]/
      @errors << "'#{self.name}' is not a valid injury name, as it does not include any letters."
    end
    if Injury.find_by_name(self.name)
      @errors << "#{self.name} already exists."
    end
    @errors.empty?
  end

  private

  def self.execute_and_instantiate(statement, bind_vars = [])
    rows = Environment.database_connection.execute(statement, bind_vars)
    results = []
    rows.each do |row|
      injury = Injury.new(row["name"])
      injury.instance_variable_set(:@id, row["id"])
      results << injury
    end
    results
  end
end
