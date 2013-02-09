require 'rack'
require_relative 'album'

class AlbumApp
  def call(env)
  	request = Rack::Request.new(env)
  	case request.path
  	when "/form"
  		render_form(request)
  	when "/list"
  		render_list(request)
  	else
  		[404, {"Content-Type" => "text/plain"}, ["Nothing here!"]]
  	end
  end

  def render_form(request)
  	response = Rack::Response.new
  	File.open("form.html", "rb") { |form| response.write(form.read)}
  	response.finish
  end

  def render_list(request)
  	response = Rack::Response.new
	albums = File.readlines("top_100_albums.txt").each_with_index.map { |s,i| Album.new(s, i+1) }
	albums.sort! { |a, b| a.send(request.params["order"].intern) <=> b.send(request.params["order"].intern) }

	response.write(
	"<html>
	 <head>
	 	<title>The List</title>
	 </head>
	 <body>
	 	<h1>Rolling Stone's Top 100 Albums of All Time</h1>
	 	<h3>Sorted by " + request.params["order"].capitalize+"</h3>
	 	<table>")

	 albums.each do |x|
	 	response.write("<tr")
	 	if x.rank==request.params["rank"].to_i
	 		response.write(" style=\"color:orange;\"")
	 	end
	 	response.write("><td> #{x.rank.to_s} </td><td> #{x.name} </td><td> #{x.year} </td></tr>")
	 end
	
	response.write("</table> </body> </html>")

	response.finish
  end

end

Rack::Handler::WEBrick.run AlbumApp.new, :Port => 8080