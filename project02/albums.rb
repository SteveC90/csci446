require 'rack'
require_relative 'album_class'

class HelloWorld
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
  #Create album class!!

  def render_list(request)
  	hash = request.GET()
	albums = File.readlines("top_100_albums.txt").each_with_index.map { |s,i| Album.new(s, i+1) }
	albums.sort! { |a, b| a.send(hash["order"].intern) <=> b.send(hash["order"].intern) }

	html = 
	"<html>
	 <head>
	 	<title>The List</title>
	 </head>
	 <body>
	 	<h1>Rolling Stone's Top 100 Albums of All Time</h1>
	 	<h3>Sorted by " + hash["order"].capitalize+"</h3>
	 	<table>"

	 albums.each do |x|
	 	html << "<tr"
	 	if x.rank==hash["rank"].to_i
	 		puts "Green!"
	 		html << " style=\"color:orange;\""
	 	end
	 	html << "><td>" << x.rank.to_s << "</td><td>" << x.name << "</td><td>" << x.year << "</td></tr>"
	 end
	
	html << "</table> </body> </html>"

	[200, {"Content-Type" => "text/html"}, [html] ]


  	#[200, {"Content-Type" => "text/plain"}, [hash["order"]]]
  end

end

Rack::Handler::WEBrick.run HelloWorld.new, :Port => 8080