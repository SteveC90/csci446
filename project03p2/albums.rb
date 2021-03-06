require 'sinatra'
require 'data_mapper'
require_relative 'album'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/albums.sqlite3.db")
set :port, 8080

post "/list" do
	@albums = Album.all(:order => params[:order].intern.asc)
	erb :list
end

get "/form" do
	@num = Album.count
	erb :form
end