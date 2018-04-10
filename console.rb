require("pry-byebug")
require_relative("./models/space_cowboy.rb")

Bounty.delete_all

bounty1 = Bounty.new({
  "name" => "Han Solo",
  "homeworld" => "earth",
  "bounty_value" => 4,
  "last_known_location" =>"Edinburgh"
  })

bounty1.save()

bounty2 = Bounty.new({
  "name" => "Captain Mal",
  "homeworld" => "mars",
  "bounty_value" => 3,
  "last_known_location" =>"Glasgow"
  })

bounty2.save()

binding.pry
nil
