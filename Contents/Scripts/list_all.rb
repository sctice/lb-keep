#!/usr/bin/env ruby
#
# LaunchBar Action Script
#

require 'json'
require_relative 'keep'

begin
  puts Keep.list_notes_by_atime(Keep.config.home).to_json
rescue Interrupt
end
