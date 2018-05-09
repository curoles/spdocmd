#!/usr/bin/env ruby

module Help

  def self.help_get_started
  puts <<~HEREDOC
    TODO
  HEREDOC

  end

  def self.help_create_issue
  puts <<~HEREDOC
    TODO
  HEREDOC
  end

  def self.help_generate_html
  puts <<~HEREDOC
    1. create a directory for HTML documentation
    2. <path to spdoc>/bin/generate-html.exs --dest <output dir> <path to spdoc>/root 
  HEREDOC
  end

end

@help_methods = Help.methods.select {|el| el.to_s.start_with? 'help_'}

def show_commands
  help_cmds = @help_methods.map {|m| m.to_s.split('_')}
  puts 'Available commands:'
  help_cmds.each do |cmd|
    puts cmd.join(' ')
  end
end

if ARGV.length < 1 
  show_commands
  exit 0
end

cmd = 'help_' + ARGV.join('_').downcase
help_method = @help_methods.find {|m| m.to_s == cmd}
if help_method == nil
  puts "Can't find command: #{cmd}"
  show_commands
  exit 0
end

Help.send(help_method)
