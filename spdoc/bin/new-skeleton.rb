#!/usr/bin/env ruby

puts "Creating spdoc skeleton..."

`ln -s -r -f bin/help.rb help`

`mkdir -p root/users/`
`ln -s -r -f bin/new-user.rb root/users/new`

`mkdir -p issues/`
`ln -s -r -f bin/new-issue.rb root/issues/new`

