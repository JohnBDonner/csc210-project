#!/usr/bin/ruby

require "cgi"
require "sqlite3"

cgi = CGI.new

user_name = cgi['name']
user_email = cgi['email']
user_password = cgi['password']

begin
	db = SQLite3::Database.new ":memory:" # Change ':memory:' to 'users.db' to write to the database
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

=begin cookie code

# my cookie code
cookie_string = cgi.cookies['mycookie']
if cookie_string
	cookie_string = CGI::Cookie.new('name' => 'mycookie',
						'value' => 'loggedin',
						'expires' => Time.now + 3600)

############
# from ruby tutorial
############
# sending a cookie
cookie = CGI::Cookie.new('name' => 'mycookie',
                         'value' => 'Zara Ali',
                         'expires' => Time.now + 3600)
cgi.out('cookie' => cookie) do
   cgi.head + cgi.body { "Cookie stored" }
end

# alternative sending of cookie
cookie = CGI::Cookie.new("rubyweb", "CustID=123", "Part=ABC");
cgi.header( "cookie" => [cookie] ,  type => 'text/html' )

# retrieving a cookie
cookie = cgi.cookies['mycookie']
cgi.out('cookie' => cookie) do
   cgi.head + cgi.body { cookie[0] }
end

=end

print cgi.header()

puts "<html>"
puts "<body>"
puts "<p>Hello, " + user_name + ". Your account has been created.</p>"
puts "<p>Your associated email to this account is " + user_email + ".</p>"
puts "</body>"
puts "</html>"