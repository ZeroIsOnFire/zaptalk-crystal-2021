require "http/server"

server = HTTP::Server.new do |context|
  context.response.content_type = "text/html"
  page = File.read("./assets/index.html")

  context.response.print page
end

puts "Conectado em http://127.0.0.1:8080"
server.listen(8080)

