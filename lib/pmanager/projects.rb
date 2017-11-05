require 'yaml'
require 'singleton'

class Pmanager::Projects
  # Singleton class
  include Singleton
  # Config file location
  FOLDER = "#{Dir.home}/.pm".freeze
  PROJECTS_FILE = "#{FOLDER}/projects.yml".freeze

  def initialize
    create! unless initialized?
    @config = YAML.load_file(PROJECTS_FILE)
  end

  # List of projects
  def projects(name = nil)
    return @config[:projects] unless name
    @config[:projects].find { |pr| pr[:name] == name }
  end

  # Add a new project!
  def add(name, dir)
    @config[:projects] << { name: name, dir: dir, options: {} }
    save @config
  end

  private

  # Check if the config is initialized
  def initialized?
    File.exists?(PROJECTS_FILE)
  end

  # Create default config file
  def create!
    system('mkdir', '-p', FOLDER) unless Dir.exists? FOLDER
    save default_config
  end

  # Save the current config
  def save(config)
    File.open(PROJECTS_FILE, 'w') { |f| YAML.dump(config, f) }
  end

  # Default values for the config file
  def default_config
    {
      version: Pmanager::VERSION,
      global: {
        git: false,
        after: ""
      },
      projects: []
    }
  end
end
