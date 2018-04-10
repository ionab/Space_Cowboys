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

  def delete()
    db = PG.connect({dbname: "space_cowboy", host: "localhost"})
    sql = "DELETE FROM bounties WHERE ID = $1"
    values = [@id]
    db.prepare("delete", sql)
    db.exec_prepared("delete", values)
    db.close()
  end

  def update()
    db = PG.connect({dbname: "space_cowboy", host: "localhost"})
    sql = "UPDATE bounties SET (name, homeworld, bounty_value, last_known_location) =
    ($1, $2, $3, $4) WHERE id = $5;"
    values = [@name, @homeworld, @bounty_value, @last_known_location, @id]
    db.prepare("update", sql)
    db.exec_prepared("update", values)
    db.close()
  end

  def self.all()
    db = PG.connect({dbname: "space_cowboy", host: "localhost"})
    sql= "SELECT * FROM bounties;"
    db.prepare("all", sql)
    cowboy = db.exec_prepared("all")
    db.close()
    return cowboy.map {|cowboy| Bounty.new(cowboy)}
  end

  def self.delete_all()
    db = PG.connect({dbname: "space_cowboy", host: "localhost"})
    sql = "DELETE FROM bounties"
    db.prepare("delete_all", sql)
    db.exec_prepared("delete_all")
    db.close()
  end

  def self.find_by_name(name)
    db = PG.connect({dbname: "space_cowboy", host: "localhost"})
    sql = "SELECT * FROM bounties WHERE name = '#{name}'"
    db.prepare("name", sql)
    cowboy = db.exec_prepared("name")
    db.close()
    @id = cowboy[0]["id"].to_i
    return cowboy.map {|cowboy| Bounty.new(cowboy)}
  end

  def self.find_by_id(id)
    db = PG.connect({dbname: "space_cowboy", host: "localhost"})
    sql = "SELECT * FROM bounties WHERE id = #{id}"
    db.prepare("id", sql)
    cowboy = db.exec_prepared("id")
    db.close()
    @id = cowboy[0]["id"].to_i
    # return Bounty.new(cowboy).to_i commented out as attempt to use without
    #using .map to get the integer. To review with Upul in morning.
    return cowboy.map {|cowboy| Bounty.new(cowboy)}
  end
end
