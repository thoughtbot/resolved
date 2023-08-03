require "spec_helper"

feature "App" do
  scenario "Visiting the homepage" do
    visit "/"

    expect(page).to have_content "Hello World"
  end
end
