#!/usr/bin/env ruby
#
# LaunchBar Action Script
#

require 'json'
require_relative 'keep'

def main
  tag = ARGV.fetch(0, '').strip
  return list_tags() if tag.empty?
  puts Keep.mdfind_by_any(tag, Keep.config.home).to_json
end

def list_tags
  items = Keep.list_tags(Keep.config.home).map do |tag|
    {
      'title' => tag,
      'action' => 'list_by_tag.rb',
      'actionArgument' => tag,
      'actionReturnsItems' => true,
      'icon' => 'tag',
    }
  end
  puts items.to_json
end

begin
  main
rescue Interrupt
end
