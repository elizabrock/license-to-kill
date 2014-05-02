class InjuryOutcome
  def self.create_for(person, injury, kill)
    statement = "Insert into injury_outcomes (person_id, injury_id, kill) values (?, ?, ?);"
    kill_int = kill ? 1 : 0
    Environment.database_connection.execute(statement, [person.id, injury.id, kill_int])
  end

  def kill?
    kill
  end
end
