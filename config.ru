require_relative "app/app"

app = Rack::Builder.new do
  use Rack::Static,
    root: "public",
    urls: ["/css", "/favicon.ico", "/404.html"],
    header_rules: [
      [%w[html], {"Content-Type" => "text/html; charset=utf-8"}],
      [:all, {"Cache-Control" => "public, max-age=31556952"}]
    ]
  run App.new
end

run app
