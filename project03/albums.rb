require 'rack'
require 'sqlite3'
require_relative 'album'

class AlbumApp
  @@DB = SQLite3::Database.new("albums.sqlite3.db")
  @@NUM = @@DB.get_first_value("select count(*) from albums")

  def call(env)
  	request = Rack::Request.new(env)
  	case request.path
  	when "/form" then render_form(request)
  	when "/list" then render_list(request)
  	else [404, {"Content-Type" => "text/plain"}, ["Nothing here!"]]
  	end
  end

  def render_form(request)
  	response = Rack::Response.new
  	response.write(ERB.new(File.read("form.html.erb")).result(binding))
  	response.finish
  end

  def render_list(request)
    response = Rack::Response.new
  	albums = @@DB.execute("select * from albums order by #{request.params["order"]}").each.map { |r| Album.new(r) }
  
  	response.write(ERB.new(File.read("list.html.erb")).result(binding))
  	response.finish
  end
end

Rack::Handler::WEBrick.run AlbumApp.new, :Port => 8080