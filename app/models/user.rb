class User < ActiveRecord::Base
	attr_accessor :remember_me
	attr_accessible :screen_name, :email, :password, :remember_me, :provider, :uid
	# Max & min lengths for all fields
	SCREEN_NAME_MIN_LENGTH = 4
	SCREEN_NAME_MAX_LENGTH = 20
	PASSWORD_MIN_LENGTH = 4
	PASSWORD_MAX_LENGTH = 40
	EMAIL_MAX_LENGTH = 50
	# Text box sizes for display in the views
	SCREEN_NAME_SIZE = 20
	PASSWORD_SIZE = 20
	EMAIL_SIZE = 20
	SCREEN_NAME_RANGE = SCREEN_NAME_MIN_LENGTH..SCREEN_NAME_MAX_LENGTH
	PASSWORD_RANGE = PASSWORD_MIN_LENGTH..PASSWORD_MAX_LENGTH
	validates_uniqueness_of :screen_name, :email
	validates_length_of :screen_name, :within => SCREEN_NAME_RANGE
	validates_length_of :password, :within => PASSWORD_RANGE
	validates_length_of :email, :maximum => EMAIL_MAX_LENGTH
	validates_format_of :screen_name,:with => /^[A-Z0-9_]*$/i,
	:message => "must contain only letters, " +
	"numbers, and underscores"
	validates_format_of :email,:with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
	:message => "must be a valid email address"
	validates_presence_of :email
	def login!(session)
		session[:user_id] = id
  end
	def self.logout!(session)
    session[:user_id] = nil
  end
	def clear_password!
    self.password = nil
	end

  def validate
    errors.add(:email,"must be valid.")unless email.include? ("@")
		if screen_name.include?(" ")
			errors.add(:screen_name, "cannot include spaces.")
    end
  end
end
#~ testing:https://makandracards.com/makandra/2945-preparing-your-test-database-mind-the-differences
#~ Functional tests :
#~ Functional tests let us simulate a browser
#~ hitting the controller actions and verify responses, redirects, variable assignments, and
#~ HTML tags.
#~ unit test:
#~ Rails unit tests let us check our model validations
#~ and make sure that the database is working.
