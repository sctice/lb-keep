#!/usr/bin/env ruby
#
# LaunchBar Action Script
#

require 'json'

require_relative 'keep.rb'

def main
  query = ARGV.fetch(0, '').strip
  items = Keep.fetch_results(query).map do |item|
    { 'title' => item['title'], 'icon' => 'page' }
  end
  puts items.to_json
end

begin
  main
rescue Interrupt
end
