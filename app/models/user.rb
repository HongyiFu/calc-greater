class User < ApplicationRecord
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:true, uniqueness: { case_sensitive: false }, format: {with: VALID_EMAIL_REGEX}
  validates :username, presence:true, uniqueness:true
  validates :password, length: { in: 8..20 }, format: {with: /(?:.*\d+.*[^\W_\d]+.*|.*[^\W_\d]+.*\w.*)/, message:"must be a combination of at least 1 alphabet and at least 1 number"}

  has_many  :portfolios, dependent: :destroy
  has_many  :authentications, dependent: :destroy

  before_validation :make_username 

  def self.create_with_auth_and_hash(authentication, auth_hash)
    u = User.new(email: auth_hash["info"]["email"])
    u.valid? # trigger errors
    counter = 2
    while u.errors.messages.keys.include?(:username) do
      u.username = "" if u.username.nil?
    	if counter == 2
    		u.username = "#{u.username}#{counter}"
    	else 
    		u.username = u.username[0..-2] + "#{counter}"
    	end
    	counter+=1
      u.valid?
    end
    u.save(validate: false)
    u.authentications << authentication
    return u
  end

  # grab fb_token to access Facebook for user data
  def fb_token
    x = self.authentications.find_by(provider: 'facebook')
    return x.token unless x.nil?
  end

	private
		def make_username
			if !self.email.nil? && (self.username.nil? || self.username == "")
				arr = self.email.scan(/\A[^@]+@/)
				self.update_attribute(:username, arr[0][0..-2]) if arr.count > 0
			end
		end

end
