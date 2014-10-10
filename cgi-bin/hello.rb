#!/usr/bin/ruby

require "cgi"
require "sqlite3"
require "securerandom"

cgi = CGI.new

user_sessionID = SecureRandom.uuid
user_name = cgi['name']
user_email = cgi['email']
user_password = cgi['password']

cookie = cgi.cookies['user_id']
if cookie.to_s() != '[]'
	# extract sessionID from cookie to display
	user_sessionID = cookie.value[0]

	puts cgi.header()

	puts "<html>"
	puts "<body>"
	puts "<p>Hello, " + user_name + ". You are already logged in.</p>"
	puts "<p>SessionID: " + user_sessionID + "</p>"
	puts "<p>There is a cookie!</p>"
	puts "<p>cookie: '" + cookie.to_s() + "'</p>"
	puts "<a href='/index.html'><button>Home</button></a>"
	puts "</body>"
	puts "</html>"
else
	# # # # # # # # # # # # # # # # #
	# insert new user into database
	# # # # # # # # # # # # # # # # #
=begin
	stm = db.prepare "SELECT * FROM User with name '"+user_name+"'" 
    rs = stm.execute
    if rs == user_name
		db = SQLite3::Database.new ":memory:" # Change ':memory:' to 'users.db' to write to the database
		db.execute "CREATE TABLE IF NOT EXISTS User(sessionID varchar(100), name varchar(100),
					email varchar(100) PRIMARY KEY, password varchar(100))"
		db.execute "INSERT INTO User VALUES('"+user_sessionID+"', '"+user_name+"',
		 '"+user_email+"', '"+user_password+"')"
=end
		# create cookie
		cookie = CGI::Cookie.new('name' => 'user_id',
	                         'value' => user_sessionID,
	                         'expires' => Time.now + 3600)
		
		puts cgi.header("cookie" => cookie)
		# puts "cookie: " + cookie.to_s()
		# cgi.out('cookie' => cookie)

		puts "<html>"
		puts "<body>"
		puts "<p>Hello, " + user_name + ". Your account has been created.</p>"
		puts "<p>Your associated email to this account is " + user_email + ".</p>"
		puts "<p>SessionID: " + user_sessionID + "</p>"
		puts "<p>You now have a NEW cookie! " + cookie.to_s() +"</p>"
		puts "<a href='/index.html'><button>Home</button></a>"
		puts "</body>"
		puts "</html>"
		
	
end

=begin
rescue SQLite3::Exception => e
	puts "Exception occured"
	puts e

ensure
	db.close if db
end

=end

=begin cookie code

# my cookie code
cookie_string = cgi.cookies['mycookie']
if cookie_string
	cookie_string = CGI::Cookie.new('name' => 'mycookie',
						'value' => 'loggedin',
						'expires' => Time.now + 3600)

############
# from ruby tutorial
############
# sending a cookie
cookie = CGI::Cookie.new('name' => 'mycookie',
                         'value' => 'Zara Ali',
                         'expires' => Time.now + 3600)
cgi.out('cookie' => cookie) do
   cgi.head + cgi.body { "Cookie stored" }
end

# alternative sending of cookie
cookie = CGI::Cookie.new("rubyweb", "CustID=123", "Part=ABC");
cgi.header( "cookie" => [cookie] ,  type => 'text/html' )

# retrieving a cookie
cookie = cgi.cookies['mycookie']
cgi.out('cookie' => cookie) do
   cgi.head + cgi.body { cookie[0] }
end

=begin

puts cgi.header()

puts "<html>"
puts "<body>"
puts "<p>Hello, " + user_name + ". Your account has been created.</p>"
puts "<p>Your associated email to this account is " + user_email + ".</p>"
puts "<p>SessionID: " + user_sessionID + "</p>"
puts "</body>"
puts "</html>"

=end