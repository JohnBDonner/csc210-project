#!/usr/bin/ruby

require 'cgi'
require 'sqlite3'

cgi = CGI.new

cookie = cgi.cookies['user_id']
if cookie.to_s() != '[]'
	### Found cookie, user is signed in ###
	puts cgi.header()
	puts '<html>'
	puts '<head>'
	puts "<script type='text/javascript' src='/assets/jquery.min.js'></script>"
	puts "<script type='text/javascript' src='/assets/script.js'></script>"
	puts '</head>'
	puts '<body>'

	user_sessionID = cookie.value[0]
	begin
		db = SQLite3::Database.new "users.db"
		# go into database
		db.execute "CREATE TABLE IF NOT EXISTS users(name varchar(100),
						email varchar(100) PRIMARY KEY, password varchar(100), sessionID varchar(100), bio text);"
		stm = db.prepare "SELECT * FROM users WHERE sessionID='"+user_sessionID+"';"
		rs = stm.execute
		db_user = rs.next_hash

		stm = db.prepare "SELECT rowid, * FROM users;"
		rs = stm.execute

		# Need to check information against signed in user...
		puts "<h3>Users</h3>"

		# # # # # # # # # #
		# user ID might not be fully unique (can condense the database table and reset id numbers)
		# so it might be a good idea to change our "Primary Key" to a new column that autoincrements
		# called "user_id" or something like that.
		# # # # # # # # # #
		notNil = true
		while notNil
			tempUser = rs.next_hash
			if !tempUser.nil?
				email = tempUser['email']
				name = tempUser['name']
				id = tempUser['user_id'].to_s
				if email != db_user['email']
					puts "<a href='user.rb?id="+id+"' data=><li class='userItem' id='userid"+id+"'>"+id+" | "+name+"</li></a>"
				else
					puts "<li class='userItem' id='userid"+id+"'>"+id+" | "+name+"</li>"
				end
			else
				notNil = false
			end
		end

		puts '<a href="home.rb"><button>Home</button></a>'


		puts '</body>'
		puts '</html>'

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