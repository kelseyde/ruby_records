require_relative("../models/album")
require_relative("../models/artist")
require_relative("../models/genre")
require_relative("../models/review")
require_relative("../models/store")
require("pry-byebug")

genre1 = Genre.new({"name" => "Indie Rock"})
genre1.save
genre2 = Genre.new({"name" => "Indie Pop"})
genre2.save

artist1 = Artist.new({"name" => "Arcade Fire"})
artist1.save

album1 = Album.new({
  "title" => "The Suburbs",
  "artist_id" => artist1.id,
  "genre_id" => genre1.id,
  "artwork" => "the_suburbs.jpg",
  "sold" => 50,
  "current_stock" => 10,
  "target_stock" => 15,
  "buy_price" => 5,
  "sell_price" => 7
  })
album1.save

album2 = Album.new({
  "title" => "Reflektor",
  "artist_id" => artist1.id,
  "genre_id" => genre2.id,
  "artwork" => "reflektor.jpeg",
  "sold" => 45,
  "current_stock" => 8,
  "target_stock" => 12,
  "buy_price" => 6,
  "sell_price" => 8
  })
album2.save

review1 = Review.new({
  "review" => "Great album.",
  "rating" => 10,
  "album_id" => album1.id
  })
review1.save

review2 = Review.new({
  "review" => "Pretentious nonsense.",
  "rating" => 3,
  "album_id" => album1.id
  })
review2.save

review3 = Review.new({
  "review" => "Good, but nothing on The Suburbs.",
  "rating" => 8,
  "album_id" => album2.id
  })
review3.save

store1 = Store.new({
  "name" => "Ruby Records",
  "location" => "22 Chancellor Street",
  "cash" => 2000
  })
store1.save

binding.pry
nil
