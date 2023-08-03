require "spec_helper"

RSpec.describe App, type: :request do
  include Rack::Test::Methods

  def app
    Rack::Builder.parse_file("config.ru")
  end

  describe "/" do
    it "returns a 200 status" do
      get "/"

      expect(last_response.status).to eq 200
    end
  end
end
