#!/usr/bin/env ruby

puts "Creating spdoc skeleton..."

`mkdir -p users/`
`ln -s -r bin/new-user.bash users/new`
