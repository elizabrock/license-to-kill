class InjuryOutcome
  def self.create_for(person, injury, kill)
    statement = "Insert into injury_outcomes (person_id, injury_id, kill) values (?, ?, ?);"
    kill_int = kill ? 1 : 0
    Environment.database_connection.execute(statement, [person.id, injury.id, kill_int])
  end

  def self.for(person, injury)
    return if person.nil? or injury.nil?
    statement = "Select kill from injury_outcomes where person_id = ? and injury_id = ?"
    result = Environment.database_connection.execute(statement, [person.id, injury.id])
    return nil if result.empty?
    ( result[0]["kill"] == 1 )
  end
end
