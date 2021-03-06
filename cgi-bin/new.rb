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
	# cookie found
	puts cgi.header("status" => "302", "location" => "home.rb")
else
	# cookie not found
	# if username, email or password is empty, then return to signup
	if user_name == '' || user_email == '' || user_password == ''
		puts cgi.header("status" => "302", "location" => "signup.rb")
	else
		# form is complete
		# insert new user into database
		begin
			db = SQLite3::Database.new "users.db" # Change ':memory:' to 'users.db' to write to the database
			# db.execute "CREATE TABLE IF NOT EXISTS users(name varchar(100),
			#				email varchar(100) PRIMARY KEY, password varchar(100));"
			stm = db.prepare "SELECT * FROM users WHERE email='"+user_email+"';" 
		    rs = stm.execute
		    if rs.next_hash.nil?
		    	# database returned nil on searching for inputed email; make new user
				db.execute "CREATE TABLE IF NOT EXISTS users(user_id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(100),
							email varchar(100), password varchar(100), sessionID varchar(100), bio text);"
				db.execute "INSERT INTO users (name, email, password, sessionID, bio) VALUES(?, ?, ?, ?, ?);", [user_name, user_email, user_password, user_sessionID, '']
				
				# create cookie
				cookie = CGI::Cookie.new('name' => 'user_id',
			                         'value' => user_sessionID,
			                         'expires' => Time.now + (60*60*24*7))
				
				# redirect to signup
				# need to add flash message that tells user that the email already exists
				puts cgi.header("status" => "302", "location" => "home.rb", "cookie" => cookie)
			else
				# database returned with the inputed email; cannot make new user
				# redirect to signup
				# need to add flash message that tells user that the email already exists
				puts cgi.header("status" => "302", "location" => "signup.rb")
			end

		rescue SQLite3::Exception => e
			puts "Exception occured"
			puts e

		ensure
			db.close if db
		end
	end
end

=begin
# try to get the cookie from the browser
cookie = cgi.cookies['user_id']
if cookie.to_s() != '[]'
	# cookie found
	# extract sessionID from cookie to display
	user_sessionID = cookie.value[0]

	# go into database
	db = SQLite3::Database.new "users.db"
	db.execute "CREATE TABLE IF NOT EXISTS users(user_id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(100),
					email varchar(100), password varchar(100), sessionID varchar(100), bio text);"
	stm = db.prepare "SELECT * FROM users WHERE sessionID='"+user_sessionID+"';"
	rs = stm.execute
	db_user = rs.next_hash

	# print the html code
	puts cgi.header()

	puts "<html>"
	puts "<body>"
	puts "<p> cookie found </p>"
	puts "<p>Hello, " + db_user['name'] + ". You are already logged in.</p>"
	puts "<p>SessionID: " + user_sessionID + "</p>"
	puts "<p>There is a cookie!</p>"
	puts "<p>cookie: '" + cookie.to_s() + "'</p>"
	puts "<a href='home.rb'><button>Home</button></a>"
	puts "</body>"
	puts "</html>"
else
	# cookie NOT found
	# insert new user into database
	db = SQLite3::Database.new "users.db" # Change ':memory:' to 'users.db' to write to the database
	# db.execute "CREATE TABLE IF NOT EXISTS users(name varchar(100),
	#				email varchar(100) PRIMARY KEY, password varchar(100));"
	stm = db.prepare "SELECT * FROM users WHERE email='"+user_email+"';" 
    rs = stm.execute
    if rs.next_hash.nil?
    	# database returned nil on searching for inputed email; make new user
		db.execute "CREATE TABLE IF NOT EXISTS users(user_id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(100),
					email varchar(100), password varchar(100), sessionID varchar(100), bio text);"
		db.execute "INSERT INTO users (name, email, password, sessionID, bio) VALUES(?, ?, ?, ?, ?);", [user_name, user_email, user_password, user_sessionID, '']
		
		# create cookie
		cookie = CGI::Cookie.new('name' => 'user_id',
	                         'value' => user_sessionID,
	                         'expires' => Time.now + (60*60*24*7))
		
		# redirect to signup
		# need to add flash message that tells user that the email already exists
		puts cgi.header("status" => "302", "location" => "home.rb", "cookie" => cookie)
	else
		# database returned with the inputed email; cannot make new user
		# redirect to signup
		# need to add flash message that tells user that the email already exists
		puts cgi.header("status" => "302", "location" => "signup.rb")
	end
end

rescue SQLite3::Exception => e
	puts "Exception occured"
	puts e

ensure
	db.close if db
end
=end