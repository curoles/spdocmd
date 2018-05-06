#!/usr/bin/env ruby

module Help

  def help_get_started

  end

  def help_create_issue

  end

  def some_method

  end
end

puts Help.instance_methods.select {|el| el.to_s.start_with? 'help_'}
