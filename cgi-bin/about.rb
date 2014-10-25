#!/usr/bin/ruby
# encoding: utf-8

require 'cgi'
require 'sqlite3'

cgi = CGI.new


cookie = cgi.cookies['user_id']
if cookie != '[]'
	user_sessionID = cookie.value[0]
	db = SQLite3::Database.new "users.db"

	# go into database
	db.execute "CREATE TABLE IF NOT EXISTS users(name varchar(100),
					email varchar(100) PRIMARY KEY, password varchar(100), sessionID varchar(100), bio text);"
	stm = db.prepare "SELECT * FROM users WHERE sessionID='"+user_sessionID+"';"
	rs = stm.execute
	db_user = rs.next_hash

	puts cgi.header()

	puts '<html>'
	puts '<head>'
	puts '<title></title>'
	puts '</head>'
	puts '<body>'
	puts '<h3>About me</h3>'
	puts '<section class=”about form”>'
	puts "<form name='about' action='user.rb' method='post' accept-charset='utf-8'>"
	puts '<textarea name="comments" cols="25" rows="5" placeholder="tell us a bit about yourself...">'
	puts db_user['bio']
	puts '</textarea><br>'
	puts '<input type="submit" value="Submit" />'
	puts '</form>'
	puts '</section>'
	puts '</body>'
	puts '</html>'
else
	puts cgi.header("status" => "302", "location" => "home.rb")
end