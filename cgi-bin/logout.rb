#!/usr/bin/ruby

require 'cgi'
require 'sqlite3'

cgi = CGI.new

cookie = cgi.cookies['user_id']
sessionID = cookie.value[0]

cookie = CGI::Cookie.new('name' => 'user_id', 'value' => sessionID, 'expires' => Time.new(2000))

puts cgi.header("status" => "302", "location" => "home.rb", "cookie" => cookie)