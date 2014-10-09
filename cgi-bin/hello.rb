#!/usr/bin/ruby

require "cgi"
require "sqlite3"

=begin
cgi = CGI.new

form = cgi.params
=end

begin

	db = SQLite3::Database.new ":memory:"
	puts db.get_first_value 'SELECT SQLITE_VERSION()'

rescue SQLite3::Exception => e

	puts "Exception occured"
	puts e

ensure
	db.close if db
end

=begin

print cgi.header()

puts "<html>"
puts "<body>"
puts "hello"
puts "</body>"
puts "</html>"

=end