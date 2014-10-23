#!/usr/bin/ruby

require 'cgi'
require 'erb'


cgi = CGI.new

puts cgi.header()

erb = ERB.new(File.open("./test.html.erb").read)
puts erb.result


=begin
cgi.out{
	cgi.html{
		cgi.head{
			cgi.title{"test"}
		}
		cgi.body{
			cgi.p{"hello in ruby"}
			cgi.a{"hello"}
		}
	}
}
=end

