#!/usr/bin/ruby

require 'cgi'
require 'sqlite3'
require_relative 'header.rb'

cgi = CGI.new

cookie = cgi.cookies['user_id']
if cookie.to_s() != '[]'
	# user is signed in
	puts cgi.header()
	puts "<html>"
	puts "<head>"
	puts "<link rel='stylesheet' type='text/css' href='/assets/normalize.css'>"
	puts "<link rel='stylesheet' type='text/css' href='/assets/style.css'>"
	puts "<script type='text/javascript' src='/assets/jquery.min.js'></script>"
	puts "<script type='text/javascript' src='/assets/script.js'></script>"
	puts "<title>title</title>"
	puts "</head>"
	puts "<body>"
	pageHeader()
	puts "<div class='body-container'>"
	puts "<div class='content'>"
	puts "<h1>Create a new topic</h1>"
	puts "<div id='topic'>"
	# start form
	puts "<form name='createTopic' action='newTopic.rb' method='post' accept-charset='utf-8'>"
	puts "<textarea class='topic_form_element' id='topicTitle_form' name='topic_title' cols='40' rows='1' placeholder='Title'></textarea>"
	# puts "<textfield id='topicTitle_form' name='topic_title' cols='25' rows='5' placeholder='Title'></textfield>"
	puts "<textarea class='topic_form_element' id='topicDesc_form' name='topic_desc' cols='80' rows='3' placeholder='Description'></textarea>"
	puts "<input type='submit' value='Create Topic'>"
	puts "</form>"
	# end form
	puts "</div>"
	puts "</div>"
	puts "</div>"
	puts "</body>"
	puts "</html>"
else
	# user is NOT signed in
	puts cgi.header("status" => "302", "location" => "home.rb")
end