require "sqlite3"

class Database < SQLite3::Database
  def initialize(database)
    super(database)
    self.results_as_hash = true
  end

  def self.connection(environment)
    @connection ||= Database.new("db/license_to_kill_#{environment}.sqlite3")
  end

  def create_tables
    self.execute("CREATE TABLE injuries (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(50))")
    self.execute("CREATE TABLE people (id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(50))")
    self.execute("CREATE TABLE injury_outcomes (id INTEGER PRIMARY KEY AUTOINCREMENT, person_id INTEGER, injury_id INTEGER, kill INTEGER)")
  end

  def execute(statement, bind_vars = [])
    Environment.logger.info("Executing: " + statement)
    super(statement, bind_vars)
  end
end
