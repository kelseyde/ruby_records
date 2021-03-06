require_relative("album")
require_relative("artist")
require_relative("genre")
require_relative("review")

class Store

  attr_reader(:id)
  attr_accessor(:name, :location, :cash)

  def initialize(info)
    @id = info["id"].to_i if info["id"]
    @name = info["name"]
    @location = info["location"]
    @cash = info["cash"].to_i
  end

  def self.map_items(store_hash)
    return store_hash.map {|store| Store.new(store)}
  end

  def save
    sql = "INSERT INTO stores(name, location, cash) VALUES($1, $2, $3) RETURNING id;"
    store = SqlRunner.run(sql, [@name, @location, @cash])
    @id = store[0]["id"].to_i
  end

  def self.all
    sql = "SELECT * FROM stores;"
    return Store.map_items(SqlRunner.run(sql))
  end

  def update()
      sql = "UPDATE stores SET (name, location, cash) =
             ($1, $2, $3) WHERE id = $4;"
      SqlRunner.run(sql, [@name, @location, @cash, @id])
    end

  def self.find(id)
    sql = "SELECT * FROM stores WHERE id = $1;"
    return Store.map_items(SqlRunner.run(sql,[id]))
  end

  def self.delete_by_id(id)
    SqlRunner.run("DELETE FROM stores WHERE id = $1;", [id])
  end

  def self.delete_all()
    SqlRunner.run("DELETE FROM stores;")
  end


  def can_i_afford?(album, quantity=1)
    return "Incorrect input." if album.class != Album
    return "Incorrect input." if quantity.class != Integer
    return @cash >= (album.buy_price * quantity)
  end

  def buy_albums(album, quantity=1)
    return "Incorrect input." if album.class != Album
    return "Incorrect input." if quantity.class != Integer
    return "Insufficient funds." if can_i_afford?(album, quantity) == false
    @cash -= (album.buy_price * quantity)
    album.current_stock += quantity
  end

  def sell_albums(album, quantity=1)
    return "Incorrect input" if album.class != Album
    return "Incorrect input" if quantity.class != Integer
    if album.current_stock > quantity
      return "You do not have #{quantity.to_s} copies of #{album.title} in stock."
             "Copies of #{album.title} currently in stock: #{album.current_stock}"
    end
    @cash += (album.sell_price * quantity)
    album.current_stock -= quantity
    return "You have sold #{quantity.to_s} copies of #{album.title}."
           "Copies of #{album.title} left in stock: #{album.current_stock}"
  end

  def stock_update(album)
    return "Incorrect input" if album.class != Album
    quantity = album.target_stock - album.current_stock
    album.current_stock += quantity
    @cash -= (album.buy_price * quantity)
  end


end
