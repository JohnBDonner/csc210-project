#!/usr/bin/ruby

require 'cgi'
require 'sqlite3'
require 'json'

cgi = CGI.new

cookie = cgi.cookies['user_id']
topic_id = cgi['topic_id'].scan( /\d+$/ ).first.to_s
if topic_id.nil?
	topic_id = '0'
end
post_id = cgi['post_id'].scan( /\d+$/ ).first.to_s
if post_id.nil?
	post_id = '0'
end

if cookie.to_s() != '[]'
	# there is a cookie, get current user
	user_sessionID = cookie.value[0]
	begin
		db = SQLite3::Database.new "users.db"

		db.execute "CREATE TABLE IF NOT EXISTS users(user_id INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(100),
							email varchar(100), password varchar(100), sessionID varchar(100));"
		stm = db.prepare "SELECT * FROM users WHERE sessionID='"+user_sessionID+"';"
		rs = stm.execute
		current_user = rs.next_hash

		if !current_user.nil?
			# user exists and has that cookie, proceed to create post
			# get post

			currentTime = Time.new
			db.execute "create table IF NOT EXISTS post(post_id INTEGER PRIMARY KEY AUTOINCREMENT, 
				topic_id INTEGER, user_id INTEGER, url text, content text, 
				up_votes INTEGER, created_at varchar(100), updated_at varchar(100));"
			tempPostPrepare = db.prepare "SELECT * FROM post where post_id=?"
			tempPostPrepare.bind_param 1, post_id
			tempPost = tempPostPrepare.execute
			currentPost = tempPost.next_hash

			newVoteNumber = currentPost['up_votes'].to_i - 1

			# Update votes
			db.execute "create table if not exists vote(vote_id INTEGER PRIMARY KEY AUTOINCREMENT, post_id INTEGER, user_id INTEGER, updated_at varchar(100));"
			db.execute "DELETE FROM vote WHERE post_id=? AND user_id=?;", [post_id, current_user['user_id']]
			# Update topic's number of votes
			db.execute "UPDATE post SET up_votes=? WHERE post_id=?;", [newVoteNumber.to_s, post_id]
			# updated the topic, so update the time
			db.execute "CREATE TABLE IF NOT EXISTS topic(topic_id INTEGER PRIMARY KEY AUTOINCREMENT, 
						user_id INTEGER, title varchar(300), desc text, created_at varchar(100), updated_at varchar(100));"
			db.execute "UPDATE topic SET updated_at=? WHERE topic_id=?", [currentTime.to_s, topic_id]

			# get the latest post
			tempPostPrepare = db.prepare "SELECT * FROM post where post_id=?"
			tempPostPrepare.bind_param 1, post_id
			tempPost = tempPostPrepare.execute
			updatedPost = tempPost.next_hash

			# Print out json header and json hash string
			puts cgi.header("type" => "application/json")
			myHash = {:post_up_votes => updatedPost['up_votes'].to_s}
			puts myHash.to_json

=begin
			# Test JSON calls without database.
			puts cgi.header("type" => "application/json")
			myHash = {:post_url => post_url, :post_content => post_content}
			puts myHash.to_json
=end

		end

	rescue SQLite3::Exception => e
		puts "Exception occured"
		puts e

	ensure
		# db.close if db
	end


end