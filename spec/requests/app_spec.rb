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

    it "is compressed" do
      get "/", {}, {"HTTP_ACCEPT_ENCODING" => "gzip"}

      expect(last_response.headers["Content-Encoding"]).to eq "gzip"
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
      resolver = instance_double(Resolv::DNS)
      ns_resource = instance_double(Resolv::DNS::Resource::IN::NS)
      allow(Resolv::DNS).to receive(:new).and_return(resolver)
      allow(resolver).to receive(:getresources).and_return([ns_resource])
      allow(ns_resource).to receive(:name).and_return("server.net")

      get "/?url=https://example.com"

      expect(last_response.status).to eq 200
      expect(last_response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
    end

    context "when there are no results" do
      it "returns a 422 status" do
        resolver = instance_double(Resolv::DNS)
        allow(Resolv::DNS).to receive(:new).and_return(resolver)
        allow(resolver).to receive(:getresources).and_return([])

        get "/?url=https://no-name-servers.com"

        expect(last_response.status).to eq 422
        expect(last_response.body).to match "Could not resolve DNS records for no-name-servers.com"
      end
    end
  end

  describe "/styles.css" do
    it "is cached" do
      get "/css/styles.css"

      expect(last_response.headers["Cache-Control"]).to eq "public, max-age=31556952"
    end

    it "is compressed" do
      get "/css/styles.css", {}, {"HTTP_ACCEPT_ENCODING" => "gzip"}

      expect(last_response.headers["Content-Encoding"]).to eq "gzip"
    end
  end
end
