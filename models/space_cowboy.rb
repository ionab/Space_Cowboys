require("pg")

class Bounty

attr_reader :id #getters, your id will be allocated by the database, you don't want to be able to write this, as you will get an error
attr_accessor :name, :homeworld, :bounty_value, :last_known_location #accessors

  def initialize(bounties) #maybe call this options instead. #setting up you class blueprint
    @id = bounties["id"].to_i
    @name = bounties["name"]
    @homeworld = bounties["homeworld"]
    @bounty_value = bounties["bounty_value"]
    @last_known_location = bounties["last_known_location"]
  end

  def save() #not a class method, so not Bounty.save() so saving a new row.
    db = PG.connect({dbname: "space_cowboy", host: "localhost"}) #conect to your database and tell it what database it is and where it is located
    sql = "INSERT INTO bounties (
      name, homeworld, bounty_value, last_known_location) VALUES ($1, $2, $3, $4) RETURNING id;" #always give the SQL as a string. #dollar values are for sanitising
      #in SQL you can assign values. In Ruby you want to assign properties, so the @id. etc.
      #but you want these to be able to be sanitised below so you assign dollar placeholders
      #otherwise you would use '#{}' <- this string interpolation but this opens you up to hackers.
    values = [@name, @homeworld, @bounty_value, @last_known_location]
      #replace your $ with the variables that you want to pass in
    db.prepare("save", sql)#package up whats above it.
    result = db.exec_prepared("save", values) #executed sql, using the values represented by the $
    @id = result[0]["id"].to_i #assign the id in the hash to the id variable. id is assigned by the database
    db.close() #close your connection
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

  def self.all() #a self because you're calling it on the whole class and not on a specific instance of the class.
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
    sql = "SELECT * FROM bounties WHERE name = $1"
    values = [name]
    db.prepare("name", sql)
    cowboy = db.exec_prepared("name", values)
    db.close()
    @id = cowboy[0]["id"].to_i
    return cowboy.map {|cowboy| Bounty.new(cowboy)}
  end

  def self.find_by_id(id)
    db = PG.connect({dbname: "space_cowboy", host: "localhost"})
    sql = "SELECT * FROM bounties WHERE id = $1"
    values = [id]
    db.prepare("id", sql)
    cowboy = db.exec_prepared("id", values)
    db.close()
    @id = cowboy[0]["id"].to_i
    cowboy_hash = cowboy[0]  #convert here from database object to a ruby object
    return Bounty.new(cowboy_hash)
  end
end
