require 'rack'

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

  def render_list(request)
  	hash = request.GET()
	albums = Array.new
	file = File.new("top_100_albums.txt", "r")
	counter = 1
	while line = file.gets do
		temp = line.split(',').collect { |x| x.strip }
		temp << counter
		counter += 1
		albums << temp
	end
	file.close

	if hash["order"]=="name"
		albums.sort! { |a,b| a[0] <=> b[0] }
	elsif hash["order"]=="year"
		albums.sort! { |a,b| a[1] <=> b[1] }
	end

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
	 	if x[2]==hash["rank"].to_i
	 		html<<"style=\"color:green\""
	 	end
	 	html << "><td>" << x[2] << "</td><td>" << x[0] << "</td><td>" << x[1] << "</td></tr>"
	 end
	
	html << "</table> </body> </html>"

	[200, {"Content-Type" => "text/html"}, html ]


  	#[200, {"Content-Type" => "text/plain"}, [hash["order"]]]
  end

end

Rack::Handler::WEBrick.run HelloWorld.new, :Port => 8080