#!/usr/bin/env ruby

puts "Creating spdoc skeleton..."

`mkdir -p users/`
`ln -s -r bin/new-user.rb users/new`

`mkdir -p issues/`
`ln -s -r bin/new-issue.rb issues/new`

