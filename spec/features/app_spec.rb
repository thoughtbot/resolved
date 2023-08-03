require "spec_helper"

feature "App" do
  scenario "Visiting the homepage" do
    visit "/"

    expect(page).to have_content "Resolved"
    expect(page).to have_content "Enter a domain name"
  end
end
