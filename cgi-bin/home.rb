#!/usr/bin/ruby

require 'cgi'
require 'sqlite3'

cgi = CGI.new

puts cgi.header()

# passwords
# https ... send password to server and the server will then hash and mangle up the password,
# javascript library -- lookup 'password widget ruby'

# print the home application html
puts "<html>"
puts "<head>"
puts "<script type='text/javascript' src='/assets/jquery.min.js'></script>"
puts "<script type='text/javascript' src='/assets/script.js'></script>"
puts "<title>title</title>"
puts "</head>"
puts "<body>"
puts "<h1>CSC 210 Project</h1>"
puts "<h3>by Brian Shin & John Donner</h3>"

# change the content if the user is logged in
# try to get the cookie from the browser
cookie = cgi.cookies['user_id']
if cookie.to_s() != '[]'
	# found a cookie, assign variable user_sessionID to cookie value to find user
	user_sessionID = cookie.value[0]

	# go into database and find user
	db = SQLite3::Database.new "users.db"
	db.execute "CREATE TABLE IF NOT EXISTS users(name varchar(100),
					email varchar(100) PRIMARY KEY, password varchar(100), sessionID varchar(100));"
	stm = db.prepare "SELECT * FROM users WHERE sessionID='"+user_sessionID+"';"
	rs = stm.execute
	db_user = rs.next_hash

	puts "<h4>Welcome " + db_user['name'] + ", you are signed in. If you want, you can logout below.</h4>"
	puts "<a data-method='DELETE' href='logout.rb' rel='nofollow'><button>logout</button></a>"
	puts "<a href='user.rb'><button>Profile</button></a>"
	puts "<a href='showUsers.rb'><button>Users</button></a>"
	# Code from rails: <a data-method="delete" href="/signout" rel="nofollow">Sign out</a>
else
	# no cookie, no one's signed in
	puts "<a href='signup.rb'><button>signup</button></a>"
	puts "<a href='login.rb'><button>login</button></a>"
end

# finish printing body and html tails
puts "</body>"
puts "</html>"
