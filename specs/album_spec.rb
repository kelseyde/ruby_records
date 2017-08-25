require("minitest/autorun")
require("minitest/rg")
require_relative("../models/album")
require_relative("../models/artist")
require_relative("../models/review")
require_relative("../models/genre")
require_relative("../db/seeds")

class AlbumTest < Minitest::Test

  def setup
    @genre1 = Genre.new({"name" => "Indie Rock"})
    @genre1.save
    @genre2 = Genre.new({"name" => "Indie Pop"})

    @artist1 = Artist.new({"name" => "Arcade Fire"})
    @artist1.save

    @album1 = Album.new({
      "title" => "The Suburbs",
      "artist_id" => @artist1.id,
      "genre" => @genre1.id,
      "artwork" => "../public/the_suburbs",
      "sold" => 50,
      "current_stock" => 10,
      "target_stock" => 15,
      "buy_price" => 5,
      "sell_price" => 7
      })
    @album1.save

    @album2 = Album.new({
      "title" => "Reflektor",
      "artist_id" => @artist1.id,
      "genre" => @genre2.id,
      "artwork" => "../public/reflektor",
      "sold" => 45,
      "current_stock" => 8,
      "target_stock" => 12,
      "buy_price" => 6,
      "sell_price" => 8
      })
    @album2.save

    @review1 = Review.new({
      "review" => "Great album.",
      "rating" => 10,
      "album_id" => @album1.id
      })
    @review1.save

    @review2 = Review.new({
      "review" => "Pretentious nonsense.",
      "rating" => 3,
      "album_id" => @album1.id
      })
    @review2.save

    @review3 = Review.new({
      "review" => "Good, but nothing on The Suburbs.",
      "rating" => 8,
      "album_id" => @album2.id
      })
    @review3.save
  end

  def test_alphabetise
    assert_equal([@album2, @album1], Album.alphabetise)
  end



end
