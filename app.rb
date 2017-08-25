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

get "/rubyrecords/albums" do
  @albums = Album.all
  @artists = Artist.all
  @genres = Genre.all
  @reviews = Review.all
  erb(:index)
end

get "/rubyrecords/albums/:id/edit" do
  @album = Album.find(params[:id])
  @artists = Artist.all
  @genres = Genre.all
  @reviews = Review.all
  erb(:edit)
end

get "/rubyrecords/albums/:id/delete" do
  Album.delete_by_id(params[:id])
  redirect "/rubyrecords/albums"
end
