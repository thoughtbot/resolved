require "bundler"
require "erb"

Bundler.require(:default, ENV.fetch("RACK_ENV").to_sym)

class App
  def call(env)
    render("home")
  end

  private

  def render(template, status_code: 200)
    @content = render_template(template)
    body = render_template("layout")
    headers = {"Content-Type" => "text/html; charset=utf-8"}

    [status_code, headers, [body]]
  end

  def render_template(template)
    template = File.read("./app/views/#{template}.html.erb")
    erb = ERB.new(template)
    erb.result(binding)
  end
end
