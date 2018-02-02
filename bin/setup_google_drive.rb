#!/usr/bin/env ruby

require "bundler/setup"
require "process_watcher"

session = GoogleDrive::Session.from_config("gv_config.json")
if session.root_folder
  puts 'ok google!'
end
