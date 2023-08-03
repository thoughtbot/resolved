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
end
