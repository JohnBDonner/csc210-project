#!/usr/bin/ruby

require "cgi"
require "sqlite3"

cgi = CGI.new

user_name = cgi['name']
user_email = cgi['email']
user_password = cgi['password']

begin

	db = SQLite3::Database.new ":memory:"
	db.execute "CREATE TABLE IF NOT EXISTS User(name varchar(100),
	 email varchar(100) PRIMARY KEY, password varchar(100))"
	db.execute "INSERT INTO User VALUES('"+user_name+"',
	 '"+user_email+"', '"+user_password+"')"

rescue SQLite3::Exception => e

	puts "Exception occured"
	puts e

ensure
	db.close if db
end

print cgi.header()

puts "<html>"
puts "<body>"
puts "<p>Hello, " + user_name + ". Your account has been created.</p>"
puts "<p>Your associated email to this account is " + user_email + ".</p>"
puts "</body>"
puts "</html>"