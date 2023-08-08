require "spec_helper"

RSpec.describe App, type: :integration do
  include Rack::Test::Methods

  def app
    Rack::Builder.parse_file("config.ru")
  end

  describe "caching result" do
    it "sets the ETag" do
      resolver = instance_double(Resolv::DNS)
      ns_resource_one = instance_double(Resolv::DNS::Resource::IN::NS)
      ns_resource_two = instance_double(Resolv::DNS::Resource::IN::NS)
      allow(Resolv::DNS).to receive(:new).and_return(resolver)
      allow(resolver).to receive(:getresources).and_return([ns_resource_two, ns_resource_one])
      allow(ns_resource_one).to receive(:name).and_return("1.net")
      allow(ns_resource_two).to receive(:name).and_return("2.net")

      get "/?url=https://example.com"
      etag = last_response.headers["ETag"]

      expect(last_response.headers["If-None-Match"]).to be nil
      expect(etag).to_not be nil
      expect(last_response.headers["Cache-Control"]).to eq "max-age=0, private, must-revalidate"

      get "/?url=https://example.com", {}, {"HTTP_IF_NONE_MATCH" => etag}

      expect(last_response.status).to eq 304

      get "/?url=https://example.com", {}, {"HTTP_IF_NONE_MATCH" => %("new_hash")}

      expect(last_response.status).to eq 200
    end
  end

  describe "error handling" do
    it "logs the error" do
      allow(Resolv::DNS).to receive(:new).and_raise(StandardError, "expected error")

      get "/?url=https://example.com"

      expect(last_response.errors).to match "expected error"
    end
  end
end
