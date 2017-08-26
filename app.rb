require("sinatra")
require("sinatra/contrib/all")
require("pry-byebug")
require_relative("./models/store")
require_relative("./models/album")
also_reload("models/*")
also_reload("views/*")

get "/rubyrecords" do
  erb(:welcome)
end

get "/rubyrecords/home" do
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

get "/rubyrecords/albums/new" do
  @albums = Album.all
  erb(:"albums/new")
end

post "/rubyrecords/albums" do
  puts params
  @album= Album.new(params)
  @album.save
  erb(:"albums/create")
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

get "/rubyrecords/store" do
  @store = Store.all.first
  erb(:"store/index")
end
