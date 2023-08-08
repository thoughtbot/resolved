class ExceptionHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    @env = env
    @app.call(env)
  rescue StandardError, LoadError, SyntaxError => e
    if ENV["RACK_ENV"] == "development"
      raise e
    else
      logger.error("ERROR: #{e}")
      logger.error(e.backtrace.join("\n"))
      body = File.read("./public/500.html")

      [500, {"Content-Type" => "text/html; charset=utf-8"}, [body]]
    end
  end

  def logger
    @env["rack.logger"]
  end
end
