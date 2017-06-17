#!/usr/bin/env ruby
#
# LaunchBar Action Script
#

require 'fileutils'

def main
  path = ARGV.fetch(0)
  return if path.nil?
  FileUtils.mkdir_p(File.dirname(path))
  FileUtils.touch(path)
  exec('open', path)
end

begin
  main
rescue Interrupt
end
