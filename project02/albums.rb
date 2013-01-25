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
  	[200, {"Content-Type" => "text/plain"}, [hash["order"]]]
  end

end

Rack::Handler::WEBrick.run HelloWorld.new, :Port => 8080