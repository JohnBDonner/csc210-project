#!/usr/bin/ruby

require 'cgi'
require_relative 'header.rb'

cgi = CGI.new


cookie = cgi.cookies['user_id']
if cookie.to_s() != '[]'
	# cookie found
	puts cgi.header("status" => "302", "location" => "home.rb")
else
	puts cgi.header()

	puts "<html>"
	puts "<head>"
	puts "<title></title>"
	puts "<link rel='stylesheet' type='text/css' href='/assets/normalize.css'>"
	puts "<link rel='stylesheet' type='text/css' href='/assets/style.css'>"
	puts "<script type='text/javascript' src='/assets/jquery.min.js'></script>"
	puts "<script type='text/javascript' src='/assets/script.js'></script>"
	puts "</head>"
	puts "<body>"
	pageHeader()
	puts "<div class='body-container'>"
	puts "<div class='content'>"
	puts "<h3>Signup for a new account</h3>"
	puts "<section class='loginform cf'>"
	puts "<form name='login' action='new.rb' method='post' accept-charset='utf-8'>"
	puts "<ul>"
	puts "<li><label for='name'>Name</label>"
	puts "<input type='name' name='name' placeholder='Your name' required></li>"
	puts "<li><label for='email'>Email</label>"
	puts "<input type='email' name='email' placeholder='yourname@email.com' required></li>"
	puts "<li><label for='password'>Password</label>"
	puts "<input type='password' name='password' placeholder='password' required></li>"
	puts "<li>"
	puts "<input type='submit' value='Signup'></li>"
	puts "</ul>"
	puts "</form>"
	puts "</section>"
	puts "</div>"
	puts "</div>"
	puts "</body>"
	puts "</html>"
end