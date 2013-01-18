class UserController < ApplicationController
  include ApplicationHelper
  before_filter :protect, :only => :index
  skip_before_filter :verify_authenticity_token  
  def index
    @title = "RailsSpace User Hub"
  end
  
  def register
  @title = "Register"
  if param_posted?(:user)
    @user = User.new(params[:user])
    if @user.save
      @user.login!(session)
      flash[:notice] = "User #{@user.screen_name} created!"
      redirect_to_forwarding_url
    else
      @user.clear_password!
    end
  end
end
#~ def facebook_login
     #~ @@omniauth = request.env['omniauth.auth']   # This contains all the details of the user say Email, Name, Age so that you can store it in your application db.
     #~ redirect_to "/user"
   #~ end
   
def login
@title = "Log in to RailsSpace"
#~ @@omniauth = request.env['omniauth.auth']
#~ authentication = User.find_by_provider_and_uid(@@omniauth[:provider], @@omniauth[:uid])
#~ if authentication
  #~ flash[:notice] = "User  logged in!"
#~ else
 if param_posted?(:user)
  @user = User.new(params[:user])
  user = User.find_by_screen_name_and_password(@user.screen_name,@user.password)
  if user
    user.login!(session)
    if @user.remember_me == "1"
      cookies[:remember_me] = { :value   => "1", :expires => 10.years.from_now }
    end
    flash[:notice] = "User #{user.screen_name} logged in!"
    omniauth = request.env['omniauth.auth']
    redirect_to_forwarding_url
  else
    @user.clear_password!
    flash[:notice] = "Invalid screen name/password combination"
  end
end
end
def logout
  User.logout!(session)
  flash[:notice] = "Logged out"
  redirect_to :action => "index", :controller => "site"
end

private
def param_posted?(symbol)
  request.post? and params[symbol]
end

def redirect_to_forwarding_url
  if (redirect_url = session[:protected_page])
    session[:protected_page] = nil
    redirect_to redirect_url
  else
    redirect_to :action => "index"
  end
end

  def protect
   if session[:user_id].nil? && @@omniauth[:uid].nil?
    session[:protected_page] = request.url
    flash[:notice] = "Please log in first"
    redirect_to :action => "login"
    else
   return true
   end
 end
  # This will be a protected page for viewing user information.
end


#~ def self.from_omniauth(auth)
  #~ where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
    #~ user.provider = auth.provider
    #~ user.uid = auth.uid
    #~ user.oauth_token = auth.credentials.token
    #~ user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    #~ user.save!
  #~ end
#~ end
 
#~ def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
  #~ user = User.where(:provider => auth.provider, :uid => auth.uid).first
  #~ unless user
    #~ user = User.create(  provider:auth.provider,
                         #~ uid:auth.uid,
                         #~ email:auth.info.email,
                         #~ password:Devise.friendly_token[0,20]
                         #~ )
    #~ user.ensure_authentication_token!
    #~ # added extra to create authentication token for user
  #~ end
  #~ user
#~ end
