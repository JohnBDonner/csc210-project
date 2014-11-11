#!/usr/bin/ruby
# encoding: utf-8

require 'cgi'
require 'sqlite3'
require 'json'

cgi = CGI.new

cookie = cgi.cookies['user_id']

if cookie.to_s() != '[]'
	user_sessionID = cookie.value[0]
	begin
		db = SQLite3::Database.new "users.db"
		# go into database
		db.execute "CREATE TABLE IF NOT EXISTS users(name varchar(100),
						email varchar(100) PRIMARY KEY, password varchar(100), sessionID varchar(100), bio text);"
		stm = db.prepare "SELECT * FROM users WHERE sessionID='"+user_sessionID+"';"
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
