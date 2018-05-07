#!/usr/bin/env ruby

puts "Creating spdoc skeleton..."

`ln -s -r bin/help.rb users/help.rb`

`mkdir -p users/`
`ln -s -r bin/new-user.rb users/new`

`mkdir -p issues/`
`ln -s -r bin/new-issue.rb issues/new`

