class RequestMethodValidator
  def initialize(app)
    @app = app
  end

  def call(env)
    if env["REQUEST_METHOD"] != "GET"
      body = File.read("./public/405.html")

      [405, {"Content-Type" => "text/html; charset=utf-8"}, [body]]
    else
      @app.call(env)
    end
  end
end
