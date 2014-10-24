#!/usr/bin/ruby

require 'cgi'
require 'sqlite3'

cgi = CGI.new

puts cgi.header()

puts '<html>'
puts '<head>'
puts '<title></title>'
puts '</head>'
puts '<body>'
puts '<h3>About me</h3>'
puts '<section class=”about form”>'
# puts '<form name=“about” action=”user.rb” method="post">'
puts "<form name='about' action='user.rb' method='post' accept-charset='utf-8'>"
puts '<textarea name="comments" cols="25" rows="5" placeholder="tell us a bit about yourself...">'
puts '</textarea><br>'
puts '<input type="submit" value="Submit" />'
puts '</form>'
puts '</section>'
puts '</body>'
puts '</html>'