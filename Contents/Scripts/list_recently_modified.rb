#!/usr/bin/env ruby
#
# LaunchBar Action Script
#

require 'json'
require_relative 'keep'

begin
  paths = `find #{Keep.config.home} -type f -not -name '.*' -mtime -2w`
  items = paths.each_line.map do |path|
    path.strip!
    {
      'title' => Keep.path_to_title(path),
      'path' => path,
    }
  end
  puts items.to_json
rescue Interrupt
end
