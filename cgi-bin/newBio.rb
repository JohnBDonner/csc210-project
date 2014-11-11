#!/usr/bin/ruby
# encoding: utf-8

require 'cgi'
require 'sqlite3'
require 'json'

cgi = CGI.new

cookie = cgi.cookies['user_id']
newBio = cgi['bioText']
if newBio.nil?
	newBio = ''
end

if cookie.to_s() != '[]'
	user_sessionID = cookie.value[0]
	begin
		db = SQLite3::Database.new "users.db"
		# go into database
		db.execute "CREATE TABLE IF NOT EXISTS users(name varchar(100),
						email varchar(100) PRIMARY KEY, password varchar(100), sessionID varchar(100), bio text);"
		db.execute "UPDATE users SET bio = ? WHERE sessionID = ?;", [newBio, user_sessionID]
		stm = db.prepare "SELECT * FROM users WHERE sessionID='"+user_sessionID+"';"

		#stm = db.prepare "SELECT * FROM users WHERE sessionID='"+"e6b88e4a-3c59-4c60-a094-24c53f1fa916"+"';"
		rs = stm.execute
		db_user = rs.next_hash

		puts cgi.header("type" => "application/json")
		displayBio = db_user['bio']
		myHash = {:bio => displayBio}
		puts myHash.to_json

	rescue SQLite3::Exception => e
		puts "Exception occured"
		puts e

	ensure
		db.close if db
	end
end