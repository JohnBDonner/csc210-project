#!/usr/bin/ruby

require "cgi"
require "sqlite3"
require "securerandom"

cgi = CGI.new

user_sessionID = SecureRandom.uuid
user_email = cgi['email']
user_password = cgi['password']

# check if user is logged in and redirect
cookie = cgi.cookies['user_id']
if cookie.to_s() != '[]'
	# cookie found, redirect to home
	puts cgi.header("status" => "302", "location" => "home.rb")
else
	# cookie not found, check if form is complete
	if user_email == '' || user_password == ''
		puts cgi.header("status" => "302", "location" => "login.rb")
	end
end

# try to get the cookie from the browser
cookie = cgi.cookies['user_id']
if cookie.to_s() != '[]'
	# cookie found
	# extract sessionID from cookie to display
	user_sessionID = cookie.value[0]

	# go into database
	db = SQLite3::Database.new "users.db"
	db.execute "CREATE TABLE IF NOT EXISTS users(name varchar(100), email varchar(100) PRIMARY KEY, password varchar(100), sessionID varchar(100), bio text);"
	stm = db.prepare "SELECT * FROM users WHERE sessionID='"+user_sessionID+"';"
	rs = stm.execute
	db_user = rs.next_hash

	# print the html code
	puts cgi.header()

	puts "<html>"
	puts "<body>"
	puts "<p>Hello, " + db_user['name'] + ". You are already logged in.</p>"
	puts "<p>SessionID: " + user_sessionID + "</p>"
	puts "<p>There is a cookie!</p>"
	puts "<p>cookie: '" + cookie.to_s() + "'</p>"
	puts "<a href='home.rb'><button>Home</button></a>"
	puts "</body>"
	puts "</html>"
else
	# cookie NOT found
	# check database for user
	db = SQLite3::Database.new "users.db"
	db.execute "CREATE TABLE IF NOT EXISTS users(name varchar(100), email varchar(100) PRIMARY KEY, password varchar(100), sessionID varchar(100), bio text);"
	stm = db.prepare "SELECT * FROM users WHERE email='"+user_email+"';" 
    rs = stm.execute
    if rs.next_hash.nil?
    	# database returned nil on searching for inputed email; login fail
		
		# print html
		puts cgi.header("cookie" => cookie)

		puts "<html>"
		puts "<body>"
		puts "<p>That email is not in the database.</p>"
		puts "<p>Please try again or create a new account.</p>"
		puts "<a href='home.rb'><button>Home</button></a>"
		puts "<a href='login.rb'><button>Login</button></a>"
		puts "<a href='signup.rb'><button>Signup</button></a>"
		puts "</body>"
		puts "</html>"
	else
		# database returned with the inputed email; check password
		stm = db.prepare "SELECT * FROM users WHERE email='"+user_email+"';"
		rs = stm.execute
		db_user = rs.next_hash
		if db_user['password'] == user_password
			# create cookie
			cookie = CGI::Cookie.new('name' => 'user_id', 'value' => user_sessionID, 'expires' => Time.now + (60*60*24*7))
			db.execute "INSERT OR REPLACE INTO users VALUES(?, ?, ?, ?, ?);", [db_user['name'], db_user['email'], db_user['password'], user_sessionID, db_user['bio']]
			
			# print html
			puts cgi.header("cookie" => cookie)

			puts "<html>"
			puts "<body>"
			puts "<p>Hello, "+db_user['name']+", you have successfully logged in.</p>"
			puts "<a href='home.rb'><button>Home</button></a>"
			puts "<p>SessionID: " + user_sessionID + "</p>"
			puts "<p>You now have a NEW cookie! " + cookie.to_s() +"</p>"
			puts "</body>"
			puts "</html>"
		else
			# print html
			puts cgi.header()

			puts "<html>"
			puts "<body>"
			puts "<p>Your password doesn't match the password associated with that account.</p>"
			puts "<p>Please try again with \"login\" or use \"signup\" to make a new account.</p>"
			puts "<a href='home.rb'><button>Home</button></a>"
			puts "<a href='login.rb'><button>Login</button></a>"
			puts "<a href='signup.rb'><button>Signup</button></a>"
			puts "</body>"
			puts "</html>"
		end
	end
end