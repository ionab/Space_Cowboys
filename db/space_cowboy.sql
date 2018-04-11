DROP TABLE bounties;  --can use DROP TABLE IF EXISTS bounties;

CREATE TABLE bounties(
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  homeworld VARCHAR(255),
  bounty_value INT,
  last_known_location VARCHAR(255)
);
