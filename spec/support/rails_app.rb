# frozen_string_literal: true

class App < Rails::Application
end

def make_rails_app
  app = Class.new(App) do
    def self.name
      "RailsApp"
    end
  end

  app.config.logger = Logger.new(nil)
  app.config.hosts = nil
  app.config.secret_key_base = "test"
  app.config.eager_load = true
  app.initialize!

  Rails.application = app
  app
end
