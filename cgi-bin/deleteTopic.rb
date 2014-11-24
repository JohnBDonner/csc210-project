#!/usr/bin/ruby
# encoding: utf-8

require 'cgi'
require 'sqlite3'
require 'json'

cgi = CGI.new

cookie = cgi.cookies['user_id']
targetTopic_id = cgi['targetTopic'].scan( /\d+$/ ).first.to_s
if targetTopic_id.nil?
	targetTopic_id = '0'
end

if cookie.to_s() != '[]'
	user_sessionID = cookie.value[0]
	begin
		db = SQLite3::Database.new "users.db"
		# go into database
		db.execute "CREATE TABLE IF NOT EXISTS users(user_id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(100),
						email varchar(100), password varchar(100), sessionID varchar(100), bio text);"
		stm = db.prepare "SELECT * FROM users WHERE sessionID='"+user_sessionID+"';"
		# stm = db.prepare "SELECT * FROM users WHERE sessionID='3db3d326-9b72-4f40-a719-087fab8924ab';"
		rs = stm.execute
		current_user = rs.next_hash

		if !current_user.nil?
			db.execute "CREATE TABLE IF NOT EXISTS topic(topic_id INTEGER PRIMARY KEY AUTOINCREMENT, 
							user_id INTEGER, title varchar(300), desc text, created_at varchar(100), updated_at varchar(100));"
			stm = db.prepare "SELECT * FROM topic WHERE topic_id='"+targetTopic_id+"';"
			rs = stm.execute
			targetTopic = rs.next_hash

			if !targetTopic.nil?
				db.execute "DELETE FROM topic WHERE topic_id='"+targetTopic['topic_id'].to_s+"';"

				puts cgi.header("type" => "application/json")
				deletedTopic_id = targetTopic['topic_id'].to_s
				deletedTopic_title = targetTopic['title']
				myHash = {:deletedTopic_id => deletedTopic_id, :deletedTopic_title => deletedTopic_title}
				puts myHash.to_json
			end
		end

	rescue SQLite3::Exception => e
		puts "Exception occured"
		puts e

	ensure
		db.close if db
	end
else
	# puts cgi.header("status" => "302", "location" => "home.rb")
end
