require 'socket'

def client_instance(c)
  http_request = c.gets
  request = request_resource http_request
  http_response = read_file("#{request[:file]}.html")
  if http_response
    c.puts http_response
  else
    c.puts "Could not find the specified resource!"
  end
  c.flush
  c.close
end

def read_file(file)
  contents = open(file) {|f| f.read}
  puts contents
end

def request_resource(request)
  if /(?<method>\w+) \/(?<file>\w+)/ =~ request
    {:method => method, :file => file}
  end
end

server = TCPServer.open(2000)

while true
  client = server.accept
  Thread.start(client) do |c|
    client_instance(c)
  end
end
