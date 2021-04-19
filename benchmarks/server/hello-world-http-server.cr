# wrk -t4 -c100 -d30s http://localhost:3000
require "http/server"

server = HTTP::Server.new do |context|
  context.response.content_type = "text/plain"
  context.response.print "Hello world!"
end

address = server.bind_tcp 3000
puts "Listening on http://#{address}"
server.listen
