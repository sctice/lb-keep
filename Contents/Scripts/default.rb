#!/usr/bin/env ruby
#
# LaunchBar Action Script
#

require 'json'

require_relative 'keep.rb'

def main
  query = ARGV.fetch(0, '').strip
  items = Keep.fetch_results(query)
  new_path, new_name = Keep.query_to_path(query)
  if items.find_index {|i| i['path'] == new_path}.nil?
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

begin
  main
rescue Interrupt
end
