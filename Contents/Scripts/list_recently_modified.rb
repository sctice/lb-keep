#!/usr/bin/env ruby
#
# LaunchBar Action Script
#

require 'date'
require 'json'
require_relative 'keep'

begin
  puts Keep.list_notes_by_mtime(Keep.config.home, {
    :cutoff => (Date.today << 1).to_time.to_i  # 1 month ago
  }).to_json
rescue Interrupt
end
