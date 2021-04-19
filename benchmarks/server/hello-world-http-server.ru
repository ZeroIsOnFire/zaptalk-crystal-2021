module Rack
  class CommonLogger
    def log(env, status, header, began_at)
      # cadê log?
    end
  end
end


# rackup hello-world-http-server.ru -p 3000
run ->(env) { [200, {"Content-Type" => "text/plain"}, ["Hello World!"]] }
