require_relative "app/app"

app = Rack::Builder.new do
  use Rack::Static,
    root: "public",
    urls: ["/404.html"],
    header_rules: [
      [%w[html], {"Content-Type" => "text/html; charset=utf-8"}]
    ]
  run App.new
end

run app
