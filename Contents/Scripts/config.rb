require 'json'

module Keep
  class Config
    attr_accessor :home, :ext

    def initialize
      user = load_config()
      @home = File.expand_path(user.fetch('home', '~/Documents/Keep'))
      @ext = user.fetch('ext', '.md')
    end

    def load_config
      config_locations.each do |path|
        begin
          json = JSON.load(File.new(path, 'r'))
          return json if !json.nil?
        rescue Errno::ENOENT
        end
      end
      {}
    end

    def config_locations
      [File.join(ENV['HOME'], '.keep.json')]
    end
  end

  class << self
    attr_writer :config
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield config
  end
end
