#!/usr/bin/ruby

require 'cgi'
require 'sqlite3'

cgi = CGI.new

puts cgi.header()

puts '<html>'
puts '<head>'
puts '</head>'
puts '<body>'

cookie = cgi.cookies['user_id']
if cookie != '[]'
	# user has a cookie... he's logged in
	# extract sessionID from cookie to display
	user_sessionID = cookie.value[0]

	db = SQLite3::Database.new "users.db"

	if cgi.request_method == 'POST'
		db.execute "CREATE TABLE IF NOT EXISTS users(name varchar(100),
					email varchar(100) PRIMARY KEY, password varchar(100), sessionID varchar(100), bio text);"
		# db.execute "UPDATE users SET text = '"+cgi['comments']+"' WHERE sessionID ='" + user_sessionID+"?';"
		db.execute "UPDATE users SET bio = ? WHERE sessionID = ?;", [cgi['comments'], user_sessionID]
		puts "<h6 style='margin: 0 0 0 0;'>You've successfully updated your bio.</h6>"
	end

	# go into database
	db.execute "CREATE TABLE IF NOT EXISTS users(name varchar(100),
					email varchar(100) PRIMARY KEY, password varchar(100), sessionID varchar(100), bio text);"
	stm = db.prepare "SELECT * FROM users WHERE sessionID='"+user_sessionID+"';"
	rs = stm.execute
	db_user = rs.next_hash

	puts '<h1>' + db_user['name'] + '</h1>'
	puts '<h6>You are viewing your profile page. ' + 
							'Click <a data-method="DELETE" href="logout.rb"' + 
							' rel="nofollow">here</a> to logout.</h6>'

	puts '<p>bio: ' + db_user['bio'] + ' <br><a href="#">edit</a></p>'
	puts '<a href="home.rb"><button>Home</button></a>'
else
	puts '<a href="home.rb"><button>Home</button></a>'
end

puts '</body>'
puts '</html>'