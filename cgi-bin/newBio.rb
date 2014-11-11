#!/usr/bin/ruby
# encoding: utf-8

require 'cgi'
require 'sqlite3'

cgi = CGI.new

=begin
puts cgi.header("type" => "application/json")
puts '{"name": "Alice"}'

=end
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
		rs = stm.execute
		db_user = rs.next_hash

		puts cgi.header("type" => "application/json")
		displayBio = db_user['bio']
		if db_user['bio'].include? "\""
			if displayBio.include? "\\"
				displayBio = displayBio.gsub!("\\", "\\\\\\\\")
			end
			displayBio = displayBio.gsub!("\"", "\\\"")
		elsif displayBio.include? "\\"
			displayBio = displayBio.gsub!("\\", "\\\\\\\\")
		else
			displayBio = db_user['bio']
		end
		puts '{"bio": "'+displayBio+'"}'

	rescue SQLite3::Exception => e
		puts "Exception occured"
		puts e

	ensure
		db.close if db
	end
end