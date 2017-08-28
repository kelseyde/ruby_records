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
  album = Album.new(params)
  album.update
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
  @outcome = @store.can_i_afford?(@album.buy_price, @quantity)
  @amount = (@album.buy_price * @quantity)
  erb(:"albums/pay")
end

post "/rubyrecords/albums/:id/buy" do
  @album = Album.find(params[:id])
  @store = Store.all.first
  @quantity = params[:quantity].to_i
  @store.buy_albums(@album, @quantity)
  @store.save
  @album.save
  erb(:"albums/buy")
end

post "/rubyrecords/home" do
  found = Album.find_by_name(params["title"])
  redirect "rubyrecords/albums/#{found.id}/edit"
end

get "/rubyrecords/artists" do
  @artists = Artist.all
  erb(:"artists/index")
end

get "/rubyrecords/store" do
  @store = Store.all.first
  erb(:"store/index")
end
