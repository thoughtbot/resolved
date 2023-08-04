require "spec_helper"

feature "App" do
  scenario "Visiting the homepage" do
    visit "/"

    expect(page).to have_content "Resolved"
    expect(page).to have_content "Enter a domain name"
  end

  scenario "Visiting a page that does not exist" do
    visit "/invalid/path"

    expect(page).to have_content "Page not found"
  end

  scenario "Filling out form" do
    resolver = instance_double(Resolv::DNS)
    ns_resource = instance_double(Resolv::DNS::Resource::IN::NS)
    allow(Resolv::DNS).to receive(:new).and_return(resolver)
    allow(resolver).to receive(:getresources).and_return([ns_resource])
    allow(ns_resource).to receive(:name).and_return("expected-server.net")

    visit "/"

    fill_in :url, with: "https://example.com"
    click_button "Submit"

    expect(page).to have_field("url", with: "https://example.com")
    within("ul") do
      expect(page).to have_selector("li", text: "expected-server.net")
    end
  end

  scenario "Handling errors" do
    error = Resolv::ResolvError.new("expected error")
    allow(Resolv::DNS).to receive(:new).and_raise(error)

    visit "/"

    fill_in :url, with: "https://example.com"
    click_button "Submit"

    expect(page).to have_content "expected error"
    expect(page).to have_field("url", with: "https://example.com")

    visit current_path

    expect(page).to_not have_content "expect error"
  end
end
