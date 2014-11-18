#!/usr/bin/ruby

require 'cgi'
require 'sqlite3'

def pageHeader

	cgi = CGI.new

	cookie = cgi.cookies['user_id']
	if cookie.to_s() != '[]'
		# cookie found
		user_sessionID = cookie.value[0]
		loggedIn = true

		# go into database and find user
		db = SQLite3::Database.new "users.db"
		db.execute "CREATE TABLE IF NOT EXISTS users(user_id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(100),
						email varchar(100) PRIMARY KEY, password varchar(100), sessionID varchar(100));"
		stm = db.prepare "SELECT * FROM users WHERE sessionID='"+user_sessionID+"';"
		rs = stm.execute
		db_user = rs.next_hash

		currentUser_id = db_user['user_id'].to_s
		currentUser_name = db_user['name']
		currentUser_sessionID = db_user['sessionID']

	else
		# cookie not found
		loggedIn = false
	end

	puts '<div class="nav-container">'
	puts '<div class="nav">'
	# print the title
	puts '<div class="nav-title"><a href="home.rb">210 Project</a></div>'
	if loggedIn 
		puts '<div class="nav-links loggedIn">'
		# Actual links
		puts '<div class="nav-home"><a href="home.rb">Home</a></div>'
		puts '<div class="nav-users"><a href="showUsers.rb">Users</a></div>'
		puts '<div class="nav-profile"><a href="user.rb?id='+currentUser_id+'">Profile</a></div>'
		puts '<div class="nav-logout"><a data-method="DELETE" href="logout.rb" rel="nofollow">Logout</a></div>'
	else
		puts '<div class="nav-links">'
		# Actual links
		puts '<div class="login"><a href="login.rb">Login</a></div>'
		puts '<div class="signup"><a href="signup.rb">Signup</a></div>'
	end
	puts '</div>'
	puts '</div>'
	puts '</div>'
end


