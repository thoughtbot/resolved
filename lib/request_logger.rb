class RequestLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    start_time = Rack::Utils.clock_time
    status, headers, response = @app.call(env)
    request_time = Rack::Utils.clock_time - start_time

    result = {
      method: env["REQUEST_METHOD"],
      path: env["PATH_INFO"],
      status: status,
      query_hash: env["rack.request.query_hash"],
      request_time: "#{request_time.round(2)}s"
    }
    env["rack.logger"].info(result)

    [status, headers, response]
  end
end
