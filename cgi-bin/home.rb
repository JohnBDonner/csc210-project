#!/usr/bin/ruby

require 'cgi'

cgi = CGI.new

puts cgi.header()

puts "<html>"
puts "<head>"
puts "<title>title</title>"
puts "</head>"
puts "<body>"
puts "<h1>CSC 210 Project</h1>"
puts "<h3>by Brian Shin & John Donner</h3>"
puts "<a href='signup.rb'><button>signup</button></a>"
puts "<a href='login.rb'><button>login</button></a>"
puts "</body>"
puts "</html>"



=begin

<html>
<head>
	<title>:JDBS</title>
</head>
<body>
	<h1>CSC 210 Project</h1>
	<h3>by Brian Shin & John Donner</h3>
	<a href="signup.html"><button>signup</button></a>
	<a href="login.html"><button>login</button></a>
</body>
</html>

=end