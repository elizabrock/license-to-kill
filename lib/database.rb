require "sqlite3"

class Database < SQLite3::Database
  def self.connection(environment)
    @connection ||= Database.new("db/license_to_kill_#{environment}.sqlite3")
  end

  def create_tables
    # TODO: self.execute("CREATE TABLE ???")
  end

  def execute(statement)
    Environment.logger.info("Executing: " + statement)
    super(statement)
  end
end
