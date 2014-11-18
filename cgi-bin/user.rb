#!/usr/bin/ruby

require 'cgi'
require 'sqlite3'
require_relative 'header.rb'

class String
	def is_i?
		/\A[-+]?\d+\z/ === self
	end
end

cgi = CGI.new

userShow = cgi['id']
cookie = cgi.cookies['user_id']

if userShow != '' && userShow.is_i?
	# the id has a value... check for cookie
	if cookie != '[]'
		# user has a cookie... he's logged in
		# extract sessionID from cookie to display
		user_sessionID = cookie.value[0]

		begin
			# go into database
			db = SQLite3::Database.new "users.db"
			db.execute "CREATE TABLE IF NOT EXISTS users(name varchar(100),
							email varchar(100) PRIMARY KEY, password varchar(100), sessionID varchar(100), bio text);"
			stm = db.prepare "SELECT * FROM users WHERE sessionID='"+user_sessionID+"';"
			rs = stm.execute
			db_user = rs.next_hash

			# check for id number against signed in user id
			if userShow == db_user['user_id'].to_s
				# the user requested to see his own page, open his profile page
				# print out the foundations of the page
				puts cgi.header()

				puts '<html>'
				puts '<head>'
				puts "<link rel='stylesheet' type='text/css' href='/assets/normalize.css'>"
				puts "<link rel='stylesheet' type='text/css' href='/assets/style.css'>"
				puts "<script type='text/javascript' src='/assets/jquery.min.js'></script>"
				puts "<script type='text/javascript' src='/assets/script.js'></script>"
				puts '</head>'
				puts '<body>'
				pageHeader()
				puts "<div class='body-container'>"
				puts "<div class='content'>"

				# print dynamic material
				puts '<h1>' + db_user['name'] + '</h1>'
				puts '<h6>You are viewing your profile page. ' + 
								'Click <a data-method="DELETE" href="logout.rb"' + 
								' rel="nofollow">here</a> to logout.</h6>'

				puts '<div id="bio"><p>bio: ' + db_user['bio'] + ' <br><div id="inline-edit" style="display: inline-block"><a href="#">edit</a></div></p></div>'
				puts '</div>'
				puts '</div>'
				puts '</body>'
				puts '</html>'
			else
				# the user requested to see another profile page, try to access profile
				stm = db.prepare "SELECT * FROM users WHERE user_id='"+userShow+"';"
				rs = stm.execute
				otherUser = rs.next_hash
				if !otherUser.nil?
					# return user of that id, display profile page
					# print out the foundations of the page
					puts cgi.header()

					puts '<html>'
					puts '<head>'
					puts "<link rel='stylesheet' type='text/css' href='/assets/normalize.css'>"
					puts "<link rel='stylesheet' type='text/css' href='/assets/style.css'>"
					puts "<script type='text/javascript' src='/assets/jquery.min.js'></script>"
					puts "<script type='text/javascript' src='/assets/script.js'></script>"
					puts '</head>'
					puts '<body>'
					pageHeader()
					puts "<div class='body-container'>"
					puts "<div class='content'>"

					# print dynamic material
					puts '<h1>' + otherUser['name'] + "</h1>"
					puts '<h6> </h6>'
					puts '<div id="bio"><p>bio: ' + otherUser['bio'] + '</p></div>'
					puts '</div>'
					puts '</div>'
					puts '</body>'
					puts '</html>'
				else
					# did not return a user corresponding to that id
					# redirect (Change to 404)
					puts cgi.header("status" => "302", "location" => "home.rb")
				end
			end
		rescue SQLite3::Exception => e
			puts "<p>Exception occured</p>"
			puts e
		ensure
			db.close if db
		end
	else
		# user isn't logged in, so redirect to home.
		puts cgi.header("status" => "302", "location" => "home.rb")
	end
else
	# id not provided, redirect to HOME (change to custom error page or 404)
	puts cgi.header("status" => "302", "location" => "home.rb")
end

