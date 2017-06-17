#!/usr/bin/env ruby
#
# LaunchBar Action Script
#

require 'fileutils'

begin
  path = ARGV.fetch(0)
  return if path.nil?
  FileUtils.mkdir_p(File.dirname(path))
  FileUtils.touch(path)
  exec('open', path)
rescue Interrupt
end
