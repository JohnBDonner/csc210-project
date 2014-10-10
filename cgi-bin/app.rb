#!/usr/bin/ruby

###############
# Main application ???
###############

require "cgi"
require "sqlite3"

cookie = cgi.cookies['mycookie']
if cookie
	cookie = CGI::Cookie.new('name' => 'mycookie',
						'value' => 'loggedin',
						'expires' => Time.now + 3600)
	
else


=begin cookie code

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