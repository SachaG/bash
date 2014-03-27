
require 'rack'
require 'cgi'

class App
  def call(env)
    req = Rack::Request.new(env)
    params = req.params
    command = 'cd ~/Dev/gribbble && git checkout '+params["commit"]
    if command
      puts "---------------------"
      puts params
      puts command
      if command == ''
      elsif command == 'load_data'
        # load database data
        system()
      else
        system( 'touch tmp/restart.txt' )
        system( command )
        system( 'echo "'+command+'" >> log.txt' )
      end
    end
    return [200, {"Content-Type" => "text/html"}, ["executing: "+command]]
  end
end