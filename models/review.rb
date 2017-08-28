require_relative("../db/sql_runner")

class Review

  attr_reader(:id)
  attr_accessor(:review, :rating)

  def initialize(info)
    @id = info["id"].to_i if info["id"]
    @review = info["review"]
    @rating = info["rating"].to_i
    @album_id = info["album_id"]
  end

  def self.map_items(review_hash)
    return review_hash.map {|review| Review.new(review)}
  end

  def save
    sql = "INSERT INTO reviews(review, rating, album_id)
           VALUES($1, $2, $3)
           RETURNING id;"
    review = SqlRunner.run(sql, [@review, @rating, @album_id])
    @id = review[0]["id"].to_i
  end

  def self.all
    sql = "SELECT * FROM reviews;"
    return Review.map_items(SqlRunner.run(sql))
  end

  def update()
      sql = "UPDATE reviews SET (review, rating, album_id)
             = ($1, $2, $3) WHERE id = $4;"
      SqlRunner.run(sql, [@review, @rating, @album_id, @id])
    end

  def self.find(id)
    sql = "SELECT * FROM reviews WHERE id = $1;"
    return Review.map_items(SqlRunner.run(sql,[id]))
  end

  def self.delete_by_id(id)
    SqlRunner.run("DELETE FROM reviews WHERE id = $1;", [id])
  end

  def self.delete_all()
    SqlRunner.run("DELETE FROM reviews;")
  end



end
