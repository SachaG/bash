require './app'
require 'rack/cors'

# allow all origins
use Rack::Cors do
  allow do
    origins '*'
    resource '*', 
        :headers => :any, 
        :methods => [:get, :post, :options]
  end
end

use Rack::ShowExceptions
run App.new