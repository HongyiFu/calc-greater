require 'rails_helper'

RSpec.describe User, type: :model do

  context "validations" do

    it "should have username and email and password_digest" do
      should have_db_column(:username).of_type(:string)
      should have_db_column(:email).of_type(:string)
      should have_db_column(:password_digest).of_type(:string)
    end

    describe "validates presence email" do
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_presence_of(:username) }
    end

    describe "validates password" do
      it { is_expected.to validate_presence_of(:password) }
      it { is_expected.to validate_length_of(:password).is_at_least(8).is_at_most(20) }
    end

    describe "validates password is of the right combination" do
    	let(:invalid_user) { User.new(username:"abcd",email:"abcd@abcd.com",password:"123456") }
    	let(:valid_user) { User.new(username:"abcd",email:"abcd@abcd.com",password:"1234567a") }
    	it "won't create user if password is not of the right combination" do
    		invalid_user.save
    		expect( User.find_by(email:"abcd@abcd.com") ).to be nil
    	end

    	it "will create user if password is of the right combination" do
    		valid_user.save
    		expect( User.find_by(email:"abcd@abcd.com") ).not_to be nil
    	end

    end

    # happy_path
    describe "can be created when all attributes are present" do
      When(:user) { User.create( 
      	email: "raz@nextacademy.com",
        password: "1234567a",
        password_confirmation: "1234567a"
      )}
      Then { user.valid? == true }
    end

    # unhappy_path

    describe "cannot be created without a email" do
      When(:user) { User.create(username: "Josh Teng", password: "1234567a", password_confirmation: "1234567a") }
      Then { user.valid? == false }
    end


    describe "cannot be created without a password" do
      When(:user) { User.create(username: "Josh Teng", email: "josh@nextacademy.com") }
      Then { user.valid? == false }
    end



    describe "should permit valid email only" do
      let(:user1) { User.create(username: "Tom", email: "tom@nextacademy.com", password: "1234567a", password_confirmation: "1234567a")}
      let(:user2) { User.create(username: "Delilah",email: "delilah.com", password: "1234567a", password_confirmation: "1234567a") }

      # happy_path
      it "sign up with valid email" do
        expect(user1).to be_valid
      end

      # unhappy_path
      it "sign up with invalid email" do
        expect(user2).to be_invalid
      end
    end
  end

  context 'associations with dependency' do
    it { is_expected.to have_many(:portfolios).dependent(:destroy)}
    it { is_expected.to have_many(:authentications).dependent(:destroy)}
  end

end
