require_relative("../db/sql_runner")
require_relative("album")
require_relative("genre")

class Artist

  attr_reader(:id)
  attr_accessor(:name)

  def initialize(info)
    @id = info["id"].to_i if info["id"]
    @name = info["name"]
  end

  def self.map_items(artist_hash)
    return artist_hash.map {|artist| Artist.new(artist)}
  end

  def save
    sql = "INSERT INTO artists(name) VALUES($1) RETURNING id;"
    artist = SqlRunner.run(sql, [@name])
    @id = artist[0]["id"].to_i
  end

  def self.all
    sql = "SELECT * FROM artists;"
    return Artist.map_items(SqlRunner.run(sql))
  end

  def update()
      sql = "UPDATE artists SET (name) = ($1) WHERE id = $2;"
      SqlRunner.run(sql, [@name, @id])
    end

  def self.find(id)
    sql = "SELECT * FROM artists WHERE id = $1;"
    return Artist.map_items(SqlRunner.run(sql,[id]))
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM artists WHERE name = $1;"
    return Artist.map_items(SqlRunner.run(sql, [name]))
  end

  def self.delete_by_id(id)
    SqlRunner.run("DELETE FROM artists WHERE id = $1;", [id])
  end

  def self.delete_all()
    SqlRunner.run("DELETE FROM artists;")
  end

  def albums
    sql = "SELECT * FROM albums WHERE id = $1"
    result = Album.map_items(SqlRunner.run(sql, [@artist_id]))
    return result
  end



end
