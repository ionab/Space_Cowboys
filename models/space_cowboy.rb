require("pg")

class Bounty

attr_reader :id
attr_accessor :name, :homeworld, :bounty_value, :last_known_location

  def initialize(bounties)
    @id = bounties["id"].to_i
    @name = bounties["name"]
    @homeworld = bounties["homeworld"]
    @bounty_value = bounties["bounty_value"]
    @last_known_location = bounties["last_known_location"]
  end

  def save()
    db = PG.connect({dbname: "space_cowboy", host: "localhost"})
    sql = "INSERT INTO bounties (
      name, homeworld, bounty_value, last_known_location) VALUES ($1, $2, $3, $4) RETURNING id;"
    values = [@name, @homeworld, @bounty_value, @last_known_location]
    db.prepare("save", sql)
    result = db.exec_prepared("save", values)
    db.close()
    @id = result[0]["id"].to_i
  end

  def self.all()
    db = PG.connect({dbname: "space_cowboy", host: "localhost"})
    sql= "SELECT * FROM bounties;"
    db.prepare("all", sql)
    cowboy = db.exec_prepared("all")
    db.close()
    return cowboy.map {|cowboy| Bounty.new(cowboy)}
  end


end
