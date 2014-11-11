#!/usr/bin/ruby

require 'cgi'
require 'sqlite3'

cgi = CGI.new

cookie = cgi.cookies['user_id']
if cookie.to_s() != '[]'
	### Found cookie, user is signed in ###
	puts cgi.header()

	user_sessionID = cookie.value[0]
	begin
		db = SQLite3::Database.new "users.db"
		# go into database
		db.execute "CREATE TABLE IF NOT EXISTS users(name varchar(100),
						email varchar(100) PRIMARY KEY, password varchar(100), sessionID varchar(100), bio text);"
		stm = db.prepare "SELECT * FROM users WHERE sessionID='"+user_sessionID+"';"
		rs = stm.execute
		db_user = rs.next_hash

		stm = db.prepare "SELECT * FROM users;"
		rs = stm.execute

		# Need to check information against signed in user...
		puts "<h3>Users</h3>"

		while !rs.nil?
			puts "<li>" + rs.next_hash['name'] + "</li>"
		end

	rescue SQLite3::Exception => e
		puts "<p>Exception occured</p>"
		puts e
	ensure
		db.close if db
	end
else
	### Did NOT find cookie, no user signed in ###
	# redirect
	puts cgi.header("status" => "302", "location" => "home.rb")
end