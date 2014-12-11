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

topicShow = cgi['topic_id']
cookie = cgi.cookies['user_id']

if topicShow != '' && topicShow.is_i?
	# the id has a value... check for cookie
	if cookie.to_s() != '[]'
		# user has a cookie... he's logged in
		# extract sessionID from cookie to display
		user_sessionID = cookie.value[0]

		begin
			# go into database
			db = SQLite3::Database.new "users.db"
			db.execute "CREATE TABLE IF NOT EXISTS users(user_id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(100),
							email varchar(100), password varchar(100), sessionID varchar(100), bio text);"
			stm = db.prepare "SELECT * FROM users WHERE sessionID='"+user_sessionID+"';"
			rs = stm.execute
			db_user = rs.next_hash

			db.execute "CREATE TABLE IF NOT EXISTS topic(topic_id INTEGER PRIMARY KEY AUTOINCREMENT, 
						user_id INTEGER, title varchar(300), desc text, created_at varchar(100), updated_at varchar(100));"
			topic_stm = db.prepare "SELECT * FROM topic WHERE topic_id="+topicShow+";"
			topic_rs = topic_stm.execute
			currentTopic = topic_rs.next_hash

			if !currentTopic.nil?
				# found topic of corresponding id print out topic
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
				puts '<div class="topic" id="topic_id_'+currentTopic['topic_id'].to_s+'">'
				puts '<h1>' + currentTopic['title'] + "</h1>"
				puts '<div id="topicDesc"><h3>' + currentTopic['desc'] + '</h3></div>'
				puts '<div id="posts">'
				puts '<div id="newpost"><a class="createPost" href="#">Add new link</a></div>'
				# while loop printing out posts in order of most upvotes(?)
				db.execute "create table IF NOT EXISTS post(post_id INTEGER PRIMARY KEY AUTOINCREMENT, 
							topic_id INTEGER, user_id INTEGER, url text, content text, 
							up_votes INTEGER, created_at varchar(100), updated_at varchar(100));"
				post_stm = db.prepare "SELECT * FROM post WHERE topic_id=? order by updated_at desc;"
				post_stm.bind_param 1, currentTopic['topic_id']
				post_rs = post_stm.execute

				notNil = true
				while notNil
					tempPost = post_rs.next_hash
					if !tempPost.nil?
						getPostUser = db.prepare "SELECT * FROM users WHERE user_id=?"
						getPostUser.bind_param 1, tempPost['user_id']
						postUser = getPostUser.execute
						userOfPost = postUser.next_hash
						puts '<div class="postItem" id="postItem_id_'+tempPost['post_id'].to_s+'">'

						puts '<a href="'+tempPost['url']+'">'+tempPost['content']+'</a>'
						puts '<div class="postItem-user">Posted by '+userOfPost['name']+'</div>'
						puts '<div class="postItem-updated">Last updated '+tempPost['updated_at'].to_s+'</div>'

						puts '</div>'
					else
						notNil = false
					end
				end

				puts '</div>'
				puts '</div>'

				puts '</div>'
				puts '</div>'
				puts '</body>'
				puts '</html>'
			else
				# did not return a user corresponding to that id
				# redirect (Change to 404)
				puts cgi.header("status" => "302", "location" => "home.rb")
			end


# Want to check if current user is owner of topic
=begin
			# check for id number against signed in user id
			if topicShow == db_user['user_id'].to_s
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
				stm = db.prepare "SELECT * FROM users WHERE user_id='"+topicShow+"';"
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
=end
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

