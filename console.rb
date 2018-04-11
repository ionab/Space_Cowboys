require("pry-byebug")
require_relative("./models/space_cowboy.rb") #./just means stay in your current directory.

Bounty.delete_all

bounty1 = Bounty.new({ #setting up a new instance of your bounty class.
  "name" => "Han Solo",
  "homeworld" => "Corellia",
  "bounty_value" => 224190,
  "last_known_location" =>"Star Killer Base"
  })

bounty1.save()

bounty2 = Bounty.new({ #another new instance
  "name" => "Captain Mal",
  "homeworld" => "mars",
  "bounty_value" => 3,
  "last_known_location" =>"Glasgow"
  })

bounty2.save()

binding.pry
nil
