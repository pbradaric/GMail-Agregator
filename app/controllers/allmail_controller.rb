class AllmailController < ApplicationController
  def index
    config = {
      :host     => 'imap.gmail.com',
      :username => flash[:username],
      :password => flash[:password],
      :port     => 993,
      :ssl      => true
    }
		imap = Net::IMAP.new(config[:host],config[:port],config[:ssl])

    imap.login(config[:username],config[:password])
		@mail_count = imap.status('INBOX', ["MESSAGES", "RECENT", "UNSEEN"])
    imap.examine('INBOX')
    @test1 = "#{@mail_count["MESSAGES"]-30 >= 1 ? @mail_count["MESSAGES"]-30 : 1}:#{@mail_count["MESSAGES"]}"
		@current_inbox = []
# 		imap.search(["SEEN"]).each do |message_id|
		imap.search("#{@mail_count["MESSAGES"]-44 >= 1 ? @mail_count["MESSAGES"]-44 : 1}:#{@mail_count["MESSAGES"]-14}").each do |message_id|
			envelope = imap.fetch(message_id, "ENVELOPE")[0].attr["ENVELOPE"]
			@current_inbox.push("#{envelope.from[0].name}: \t#{envelope.subject}")
			@current_inbox.reverse!
      #@operation_result += 1
		end
    imap.logout
    imap.disconnect

    flash[:username] = config[:username]
    flash[:password] = config[:password]

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

#<% for header in @current_inbox %>
  #- <%=h header %><br>
#<% end %>
