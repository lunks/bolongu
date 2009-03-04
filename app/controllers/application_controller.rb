# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  helper :all
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  protected

  def current_account_owns?(object)
    object.account == current_account
  end
  
  def account_from_path
    Account.find_by_login(params[:account_login])
  end

  def friend?(account, friend)
    account.friends.include?(friend)
  end
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  #não sei pra que serve!
  #session :session_key => '_authentication_session_id'
end