require_relative("../db/sql_runner")
require_relative("artist")
require_relative("review")

class Album

  attr_reader(:id)
  attr_accessor(:title, :artist_id, :genre, :artwork, :sold,
                :current_stock, :target_stock, :buy_price, :sell_price)

  def initialize(info)
    @id = info["id"].to_i if info["id"]
    @title = info["title"]
    @artist_id = info["artist_id"].to_i
    @genre_id = info["genre_id"].to_i
    @artwork = info["artwork"]
    @sold = info["sold"].to_i
    @current_stock = info["current_stock"].to_i
    @target_stock = info["target_stock"].to_i
    @buy_price = info["buy_price"].to_i
    @sell_price = info["sell_price"].to_i
  end

  def self.map_items(album_hash)
    return album_hash.map {|album| Album.new(album)}
  end

  def save
    sql = "
      INSERT INTO albums (
        title,
        artist_id,
        genre_id,
        artwork,
        sold,
        current_stock,
        target_stock,
        buy_price,
        sell_price )
      VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8, $9 )
      RETURNING id;"
    values = [@title, @artist_id, @genre_id, @artwork, @sold,
              @current_stock, @target_stock, @buy_price, @sell_price]
    album = SqlRunner.run(sql, values)
    @id = album[0]["id"].to_i
  end

  def self.all
    sql = "SELECT * FROM albums;"
    return Album.map_items(SqlRunner.run(sql))
  end

  def update()
      sql = "
      UPDATE albums SET (
        title,
        artist_id,
        genre_id,
        artwork,
        sold,
        current_stock,
        target_stock,
        buy_price,
        sell_price ) = (
        $1, $2, $3, $4, $5, $6, $7, $8, $9)
      WHERE id = $10;"
      values = [@title, @artist_id, @genre_id, @artwork, @sold, @current_stock,
                @target_stock, @buy_price, @sell_price, @id]
      SqlRunner.run(sql, values)
    end

  def self.find(id)
    sql = "SELECT * FROM albums WHERE id = $1;"
    return Album.map_items(SqlRunner.run(sql,[id])).first
  end

  def self.find_by_name(title)
    sql = "SELECT * FROM albums WHERE title = $1;"
    return Album.map_items(SqlRunner.run(sql, [title])).first
  end

  def self.delete_by_id(id)
    sql = "DELETE FROM albums WHERE id = $1;"
    SqlRunner.run(sql, [id])
  end

  def self.delete_all()
    sql = "DELETE FROM albums;"
    SqlRunner.run(sql)
  end


  def artist
    sql = "SELECT * FROM artists WHERE id = $1;"
    return Artist.map_items(SqlRunner.run(sql, [@artist_id])).first
  end

  def reviews
    sql = "SELECT * FROM reviews WHERE album_id = $1;"
    return Review.map_items(SqlRunner.run(sql, [@id]))
  end

  def genre
    sql = "SELECT * FROM genres WHERE id = $1;"
    return Genre.map_items(SqlRunner.run(sql, [@genre_id])).first
  end

  def self.alphabetise
    return Album.all.sort_by{|album| album.title}
  end

  def avg_rating
    sql = "SELECT * FROM reviews WHERE album_id = $1"
    reviews = Review.map_items(SqlRunner.run(sql, [@id]))
    count = reviews.length
    sum = 0
    reviews.each {|review| sum += review.rating}
    return sum if sum == 0
    return sum / count
  end

  def rating_to_stars
    stars = ""
    self.avg_rating.times{ stars += "*" }
    return stars
  end

  def self.sort_by_rating
    return Album.all.sort_by{|album| album.avg_rating}
  end


  def self.low_stock
    low_stock = []
    for album in Album.all
      if album.current_stock < album.target_stock && album.current_stock > 0
        info = {
          album: album,
          below_target: album.target_stock - album.current_stock,
          cost: album.buy_price * (album.target_stock - album.current_stock)
        }
        low_stock << info
      end
    end
    return low_stock
  end

  def self.out_of_stock
    out_of_stock = []
    for album in Album.all
      if album.current_stock == 0
        info = {
          album: album,
          below_target: album.target_stock,
          cost: album.buy_price * album.target_stock
        }
        out_of_stock << info
      end
    end
    return out_of_stock
  end




  def self.cost_to_replace
    cost = 0
    low_stock.each {|info| cost += info[:cost]}
    out_of_stock.each {|info| cost += info[:cost]}
    return cost
  end


end
