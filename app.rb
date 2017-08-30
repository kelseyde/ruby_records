require("sinatra")
require("sinatra/contrib/all")
require("pry-byebug")
require_relative("./models/store")
require_relative("./models/album")
require_relative("./models/genre")
require_relative("./models/review")
also_reload("models/*")
also_reload("views/*")

get "/rubyrecords" do
  @albums = Album.alphabetise
  erb(:home)
end

get "/rubyrecords/about" do
  erb(:about)
end

get "/rubyrecords/albums" do
  @albums = Album.all
  @artists = Artist.all
  @genres = Genre.all
  @reviews = Review.all
  erb(:"albums/index")
end

get "/rubyrecords/albums/alpha" do
  @albums = Album.all
  @artists = Artist.all
  @genres = Genre.all
  @reviews = Review.all
  erb(:"albums/index_a")
end

get "/rubyrecords/albums/rating" do
  @albums = Album.all
  @artists = Artist.all
  @genres = Genre.all
  @reviews = Review.all
  erb(:"albums/index_r")
end

get "/rubyrecords/albums/alpha" do
  @albums = Album.all
  @artists = Artist.all
  @genres = Genre.all
  @reviews = Review.all
  erb(:"albums/index_alpha")
end

get "/rubyrecords/albums/new" do
  @albums = Album.all
  erb(:"albums/new")
end

post "/rubyrecords/albums" do

  artist = Artist.find_by_name(params[:artist]).first
  if artist == nil
    artist = Artist.new({"name" => params[:artist]}).save
  end

  genre = Genre.find_by_name(params[:genre]).first
  if genre == nil
    genre = Genre.new({"name" => params[:genre]}).save
  end

  params[:artist_id] = artist.id
  params[:genre_id] = genre.id

  @album = Album.new(params).save
  @albums = Album.all
  erb(:"albums/index")
end

get "/rubyrecords/albums/:id/edit" do
  @album = Album.find(params[:id])
  erb(:"albums/edit")
end

post "/rubyrecords/albums/:id" do

  artist = Artist.find_by_name(params[:artist]).first
  if artist == nil
    artist = Artist.new({"name" => params[:artist]}).save
  end

  genre = Genre.find_by_name(params[:genre]).first
  if genre == nil
    genre = Genre.new({"name" => params[:genre]}).save
  end

  params[:artist_id] = artist.id
  params[:genre_id] = genre.id
  album = Album.new(params)
  album.update
  redirect "/rubyrecords/albums"
end

post "/rubyrecords/albums/:id/delete" do
  Album.delete_by_id(params[:id])
  redirect "/rubyrecords/albums"
end

get "/rubyrecords/albums/:id/reviews" do
  @album = Album.find(params[:id])
  @reviews = @album.reviews
  erb(:"albums/reviews")
end

get "/rubyrecords/albums/:id/order" do
  @album = Album.find(params[:id])
  erb(:"albums/order")
end

post "/rubyrecords/albums/:id/pay" do
  @album = Album.find(params[:id])
  @store = Store.all.first
  @quantity = params[:quantity].to_i
  @outcome = @store.can_i_afford?(@album, @quantity)
  @amount = (@album.buy_price * @quantity)
  erb(:"albums/pay")
end

post "/rubyrecords/albums/:id/buy" do
  @album = Album.find(params[:id])
  @store = Store.all.first
  @quantity = params[:quantity].to_i
  @store.buy_albums(@album, @quantity)
  @store.update
  @album.update
  erb(:"albums/buy")
end

post "/rubyrecords/home" do
  found = Album.find_by_name(params["title"])
  redirect "/rubyrecords/notfound" if found.nil?
  redirect "/rubyrecords/albums/#{found.id}/edit"
end

get "/rubyrecords/albums/stock" do
  @low_stock = Album.low_stock
  @out_of_stock = Album.out_of_stock
  @total_cost = Album.cost_to_replace
  erb(:"albums/stock")
end

post "/rubyrecords/albums/stock/replace" do
  @store = Store.all.first
  Album.low_stock.each do |info|
    @store.stock_update(info[:album])
    info[:album].update
  end
  Album.out_of_stock.each do |info|
    @store.stock_update(info[:album])
    info[:album].update
  end
  redirect "/rubyrecords/albums"
end

get "/rubyrecords/notfound" do
  erb(:"albums/notfound")
end

get "/rubyrecords/artists" do
  @artists = Artist.all
  @albums = Album.all
  erb(:"artists/index")
end

get "/rubyrecords/store" do
  @store = Store.all.first
  erb(:"store/index")
end
