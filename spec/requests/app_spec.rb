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

  describe "invalid paths" do
    it "returns a 404 status " do
      get "/invalid/path"

      expect(last_response.status).to eq 404
    end

    it "returns an html content type" do
      get "/invalid/path"

      expect(last_response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
    end
  end

  describe "/404.html" do
    it "returns a 200 status" do
      get "/404.html"

      expect(last_response.status).to eq 200
    end

    it "returns an html content type" do
      get "/404.html"

      expect(last_response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
    end
  end

  describe "/?url=" do
    it "returns the correct response" do
      get "/?url=https://example.com"

      expect(last_response.status).to eq 200
      expect(last_response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
    end
  end
end
