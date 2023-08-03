require "bundler"

Bundler.require(:default, ENV.fetch("RACK_ENV").to_sym)

class App
  def call(env)
    [200, {}, ["Hello World"]]
  end
end
