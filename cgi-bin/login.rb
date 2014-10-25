#!/usr/bin/ruby

require 'cgi'

cgi = CGI.new

puts cgi.header()

puts "<html>"
# What's the correct way to redirect a login page?
# if statement that redirects to home if already logged in
puts "<head>"
cookie = cgi.cookies['user_id']
=begin
if cookie.to_s() != '[]'
	puts '<meta http-equiv="refresh" content="0; url=home.rb" />'
end
=end
puts "</title></title>"
puts "</head>"
puts "<body>"
puts "<h3>Login to your account</h3>"
puts "<section class='loginform cf'>"
puts "<form name='login' action='hello.rb' method='post' accept-charset='utf-8'>"
puts "<ul>"
puts "<li><label for='email'>Email</label>"
puts "<input type='email' name='email' placeholder='yourname@email.com' required></li>"
puts "<li><label for='password'>Password</label>"
puts "<input type='password' name='password' placeholder='password' required></li>"
puts "<li>"
puts "<input type='submit' value='Login'></li>"
puts "</ul>"
puts "</form>"
puts "</section>"
puts "</body>"
puts "</html>"