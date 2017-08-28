require_relative("../db/sql_runner")

class Genre

  attr_reader(:id)
  attr_accessor(:name)

  def initialize(info)
    @id = info["id"].to_i if info["id"]
    @name = info["name"]
  end

  def self.map_items(genre_hash)
    return genre_hash.map {|genre| Genre.new(genre)}
  end

  def save
    sql = "INSERT INTO genres(name) VALUES($1) RETURNING id;"
    genre = SqlRunner.run(sql, [@name])
    @id = genre[0]["id"].to_i
  end

  def self.all
    sql = "SELECT * FROM genres;"
    return Genre.map_items(SqlRunner.run(sql))
  end

  def update()
      sql = "UPDATE genres SET (name) = ($1) WHERE id = $2;"
      SqlRunner.run(sql, [@name, @id])
    end

  def self.find(id)
    sql = "SELECT * FROM genres WHERE id = $1;"
    return Genre.map_items(SqlRunner.run(sql,[id]))
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM genres WHERE name = $1;"
    return Genre.map_items(SqlRunner.run(sql, [name]))
  end

  def self.delete_by_id(id)
    SqlRunner.run("DELETE FROM genres WHERE id = $1;", [id])
  end

  def self.delete_all()
    SqlRunner.run("DELETE FROM genres;")
  end

end
