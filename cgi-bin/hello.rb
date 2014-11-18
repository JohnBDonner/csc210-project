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
	else
		# form is complete
		# check database for user
		db = SQLite3::Database.new "users.db"
		db.execute "CREATE TABLE IF NOT EXISTS users(user_id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(100),
						email varchar(100), password varchar(100), sessionID varchar(100), bio text);"
		stm = db.prepare "SELECT * FROM users WHERE email='"+user_email+"';" 
	    rs = stm.execute
	    if rs.next_hash.nil?
	    	# database returned nil on searching for inputed email; login fail
			
			# redirect to login screen
			# need a flash message to tell the user that the login failed and why
			puts cgi.header("status" => "302", "location" => "login.rb")
		else
			# database returned with the inputed email; check password
			stm = db.prepare "SELECT * FROM users WHERE email='"+user_email+"';"
			rs = stm.execute
			db_user = rs.next_hash
			if db_user['password'] == user_password
				# create cookie
				cookie = CGI::Cookie.new('name' => 'user_id', 'value' => user_sessionID, 'expires' => Time.now + (60*60*24*7))
				db.execute "UPDATE users SET sessionID=? WHERE email=?", [user_sessionID, db_user['email']]

				# send cookie to browser and redirect to home
				puts cgi.header("status" => "302", "location" => "home.rb", "cookie" => cookie)
			else
				# password didn't match, redirect to login
				# need a flash message to tell the user that the login failed and why
				puts cgi.header("status" => "302", "location" => "login.rb")
			end
		end
	end
end
