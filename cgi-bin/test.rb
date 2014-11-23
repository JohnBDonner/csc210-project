#!/usr/bin/ruby

require 'cgi'
require 'sqlite3'


cgi = CGI.new
currentTime = Time.new

puts "current time: " + Time.now.to_s

=begin

puts cgi.header()

puts "<html>"
puts "<body>"
puts "<p>Hey</p>"

db = SQLite3::Database.new "users.db"
s = "ONE"
t = "the second string"
u = "one/THIRD"


# go into database
db.execute "CREATE TABLE IF NOT EXISTS temp (content text);"
db.execute "INSERT INTO temp VALUES(?)", t
db.execute "UPDATE temp SET content = ? WHERE content != ?;", [t, u]

stm = db.prepare "SELECT * FROM temp;"
rs = stm.execute

rs.each do |row|
	puts "<p>"+row.join+"</p>"
end

puts "<p>end html</p>"

puts "</body>"
puts "</html>"

# alter table users rename to usersTemp;
# pragma table_info(users);
# create table users (name varchar(100), email varchar(100) primary key, password varchar(100), sessionID varchar(100), bio text);
# insert into users (name, email, password, sessionID, bio) select * from usersTemp;
# select * from users




=end











