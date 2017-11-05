require 'thor'
require 'fileutils'

# CLI class
class Pmanager::CLI < Thor
  desc 'add', 'Add the current folder as a project'
  def add(name)
    projects = Pmanager::Projects.instance.projects
    if projects.find { |pr| pr[:name] == name }
      puts "There is another project with '#{name}' name"
    else
      Pmanager::Projects.instance.add(name, Dir.pwd)
    end
  end

  desc 'hello', 'Hello message'
  def hello
    puts "I'm developing it! Please check https://github.com/Angelmmiguel/pm/tree/ruby"
  end

  desc 'path', 'Get the path of a project'
  def path(name)
    project = Pmanager::Projects.instance.projects(name)
    if project
      puts project[:dir]
    else
      puts "There isn't any project called #{name}"
    end
  end

  desc 'list', 'List all available projects'
  def list
    projects = Pmanager::Projects.instance.projects
    if projects.size == 0
      puts "No projects here"
    else
      projects.each do |pr|
        puts pr[:name]
      end
    end
  end
end
