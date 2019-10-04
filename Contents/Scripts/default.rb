#!/usr/bin/env ruby
#
# LaunchBar Action Script
#

require 'json'
require_relative 'keep'

def main
  return menu if ARGV.empty?
  query = ARGV.fetch(0, '').strip
  items = Keep.fetch_results(query)
  new_path, new_name = Keep.query_to_path(query)
  if !new_name.nil? && items.find_index { |i| i['path'] == new_path }.nil?
    items << {
      'title' => "Create ‹#{new_name}›",
      'action' => 'create_new.rb',
      'actionArgument' => new_path,
      'actionRunsInBackground' => true,
      'icon' => 'pencil',
    }
  end
  puts items.to_json
end

def menu
  puts [
    {
      'title' => 'Recently modified notes (4 weeks)',
      'action' => 'list_recently_modified.rb',
      'actionReturnsItems' => true,
      'icon' => 'folder',
    },
    {
      'title' => 'All notes',
      'action' => 'list_all.rb',
      'actionReturnsItems' => true,
      'icon' => 'folder',
    },
    {
      'title' => 'Tags',
      'action' => 'list_by_tag.rb',
      'actionReturnsItems' => true,
      'actionArgument' => '',
      'icon' => 'tag',
    },
  ].to_json
end

begin
  main
rescue Interrupt
end
