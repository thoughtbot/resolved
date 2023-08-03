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
    visit "/"

    fill_in :url, with: "https://example.com"
    click_button "Submit"

    expect(page).to have_field("url", with: "https://example.com")
  end
end
