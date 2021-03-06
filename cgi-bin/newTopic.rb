#!/usr/bin/ruby

=begin
def assert(condition, message)
	if !condition
		throw message || "Assertion FAILED"
	end
end
=end

require 'cgi'
require 'sqlite3'
require 'json'
# This might be better as a JSON file, but for now is a page that is separate from the topic page
require_relative 'header.rb'

cgi = CGI.new

# get information from browser
topic_title = cgi['topic_title']
topic_desc = cgi['topic_desc']

cookie = cgi.cookies['user_id']
if cookie.to_s() != '[]'
	user_sessionID = cookie.value[0]
	# cookie found, user is signed in
	if topic_title == '' || topic_desc == '' || topic_title.nil? || topic_title.nil?
		# one of the "needed" parameters are empty. Redirect to home
		# Redirect will need to change
		# Most likely will make description optional
		puts cgi.header("status" => "302", "location" => "home.rb")
		# assert(true)
	else
		# user has a title and description, create the new topic
		begin
			# Select the database "users.db"
			db = SQLite3::Database.new "users.db"
			# go into database
			db.execute "CREATE TABLE IF NOT EXISTS users(user_id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(100),
							email varchar(100), password varchar(100), sessionID varchar(100), bio text);"
			stm = db.prepare "SELECT * FROM users WHERE sessionID='"+user_sessionID+"';"
			# stm = db.prepare "SELECT * FROM users WHERE sessionID='8738aa78-7367-4dc7-9481-6c044e5a4563';"
			rs = stm.execute
			db_user = rs.next_hash

			# assert(!db_user.nil?, "user is nil")

			# Add the new topic to the topic table
			currentTime = Time.new
			db.execute "CREATE TABLE IF NOT EXISTS topic(topic_id INTEGER PRIMARY KEY AUTOINCREMENT, 
						user_id INTEGER, title varchar(300), desc text, created_at varchar(100), updated_at varchar(100));"
			db.execute "INSERT INTO topic(user_id, title, desc, created_at, updated_at) VALUES(?, ?, ?, ?, ?);", [db_user['user_id'], topic_title, topic_desc, currentTime.to_s, currentTime.to_s]
			topic_stm = db.prepare "SELECT * FROM topic order by topic_id desc limit 1;"
			topic_rs = topic_stm.execute
			newTopic = topic_rs.next_hash

			# assert(!newTopic.nil?, "new topic is nil")

			# Add the new topic-user relationship to the topic_user table
			db.execute "CREATE TABLE IF NOT EXISTS topic_user(topic_id INTEGER, user_id INTEGER);"
			db.execute "INSERT INTO topic_user(topic_id, user_id) VALUES(?, ?);", [newTopic['topic_id'], db_user['user_id']]

			newTopic_url = "topic.rb?topic_id="+newTopic['topic_id'].to_s()
			puts cgi.header("status" => "302", "location" => newTopic_url)

		rescue SQLite3::Exception => e
			puts "Exception occured"
			puts e

		ensure
			db.close if db
		end
	end
else
	# user is not logged in, redirect to home
	puts cgi.header("status" => "302", "location" => "home.rb")
end
