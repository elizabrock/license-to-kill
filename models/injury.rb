class Injury
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def self.count
    statement = "Select count(*) from injuries"
    result = Environment.database_connection.execute(statement)
    result[0][0]
  end

  def self.last
    statement = "Select * from injuries order by id DESC limit(1)"
    result = Environment.database_connection.execute(statement)
    unless result.empty?
      name = result[0]["name"]
      Injury.new(name)
    end
  end

  def save
    statement = "Insert into injuries (name) values ('#{name}')"
    Environment.database_connection.execute(statement)
    true
  end
end
