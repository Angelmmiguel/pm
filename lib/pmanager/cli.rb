require 'thor'

# CLI class
class Pmanager::CLI < Thor
  desc 'hello', 'Hello message'
  def hello
    puts "I'm developing it! Please check https://github.com/Angelmmiguel/pm/tree/ruby"
  end
end
