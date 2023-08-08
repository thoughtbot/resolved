require_relative "app/app"
require_relative "lib/exception_handler"

app = Rack::Builder.new do
  use Rack::Logger
  use Rack::ShowExceptions
  use ExceptionHandler
  use Rack::Deflater
  use Rack::ConditionalGet
  use Rack::ETag
  use Rack::Static,
    root: "public",
    urls: ["/css", "/favicon.ico", "/404.html", "/500.html"],
    header_rules: [
      [%w[html], {"Content-Type" => "text/html; charset=utf-8"}],
      [:all, {"Cache-Control" => "public, max-age=31556952"}]
    ]
  run App.new
end

run app
