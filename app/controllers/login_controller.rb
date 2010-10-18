require 'net/imap'
require 'net/http'

class LoginController < ApplicationController
  def index
    @product = ""
  end
  
  def login
    config = {
      :host     => 'imap.gmail.com',
      :username => params[:username],
      :password => params[:password],
      :port     => 993,
      :ssl      => true
    }
		imap = Net::IMAP.new(config[:host],config[:port],config[:ssl])

    imap.login(config[:username],config[:password])
    imap.logout
    imap.disconnect
    flash[:username] = params[:username]
    flash[:password] = params[:password]
    redirect_to(:controller => "allmail", :action => "index")

		# NoResponseError and ByResponseError happen often when imap'ing
		rescue Net::IMAP::NoResponseError => e
      redirect_to(:action => "index")
		# send to log file, db, or email
		rescue Net::IMAP::ByeResponseError => e
      redirect_to(:action => "index")
		# send to log file, db, or email
		rescue => e
      redirect_to(:action => "index")
		# send to log file, db, or email

  end

end
