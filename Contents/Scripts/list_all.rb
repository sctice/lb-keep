#!/usr/bin/env ruby
#
# LaunchBar Action Script
#

require 'json'
require_relative 'keep'

begin
  puts Keep.list_notes_by_mtime(Keep.config.home).to_json
rescue Interrupt
end
