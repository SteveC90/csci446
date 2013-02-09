require 'rack'
require_relative 'album'

class AlbumApp
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
	albums = File.readlines("top_100_albums.txt").each_with_index.map { |s,i| Album.new(s, i+1) }
	albums.sort! { |a, b| a.send(request.params["order"].intern) <=> b.send(request.params["order"].intern) }

	response.write(ERB.new(File.read("list.html.erb")).result(binding))
	response.finish
  end

end

Rack::Handler::WEBrick.run AlbumApp.new, :Port => 8080