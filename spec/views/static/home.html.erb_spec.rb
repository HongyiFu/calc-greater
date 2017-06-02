require 'rails_helper'

RSpec.describe "static/home.html.erb", type: :feature do

  # Capybara.register_driver :selenium do |app|
  #   Capybara::Selenium::Driver.new(app, :browser => :chrome)
  # end

  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(
      app,
      browser: :firefox,
      desired_capabilities: Selenium::WebDriver::Remote::Capabilities.firefox(marionette: false)
    )
  end
  
  # Capybara.default_max_wait_time = 5

  describe "sign up process" do
    before do
      visit '/'
    end

    it "does not display sign up modal on home page" do
      expect(page).to have_css("#signUpModal", visible:false)
    end

    it "clicking on 'You are not signed in' pops up the selection", js:true do
      click_link 'You are not signed in'
      find(:css, 'a[data-target="#signUpModal"]').click  
      expect(page).to have_css("#signUpModal", visible:true)
    end

    let(:email) { "jesuss@church.com" }
    let(:password) { "jesuss-password" }
    it "will sign up properly", js:true do
      User.delete_all
      click_link 'You are not signed in'
      find(:css, 'a[data-target="#signUpModal"]').click  
      fill_in "Email", with:email
      fill_in "Password", with:password
      fill_in "Confirm your password", with:password
      click_button 'Create Account'
      expect(page).to have_text("Successful sign up and you are now signed in!")
    end
  end

  describe "calculator process" do 
    before do 
      visit '/'
    end

    # happy path
    it "able to use calculator", js:true do
      fill_in "num_of_yrs", :with => "30"
      fill_in "starting_amt", :with => "1000"
      fill_in "contribution", :with => "100"
      fill_in "rate_of_return", :with => "5"
      click_button "Calculate"
      expect(page).to have_text("your investment could be worth")
    end

    # unhappy path, left out some field
    it "able to use calculator", js:true do
      fill_in "num_of_yrs", :with => "30"
      fill_in "starting_amt", :with => "1000"
      fill_in "contribution", :with => "100"
      click_button "Calculate"
      expect(page).not_to have_text("your investment could be worth")
      
      # expect(page).to have_css("input", :background_color => "red")
    end
  end
end


