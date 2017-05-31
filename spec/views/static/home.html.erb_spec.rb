require 'rails_helper'

RSpec.describe "static/home.html.erb", type: :feature do

  describe "sign up process and calculator usage" do
  	before do
  		visit '/'
  	end

    it "clicking on 'You are not signed in' pops up the selection" do
      click_link 'You are not signed in'
      expect(page).to have_content("Sign Up")
    end

    it "able to use calculator" do
      fill_in "num_of_yrs", :with => "30"
      fill_in "starting_amt", :with => "1000"
      fill_in "contribution", :with => "100"
    	fill_in "rate_of_return", :with => "5"
      click_button "Calculate"
      expect(page).to have_text("your investment could be worth")
		end

  end
end


