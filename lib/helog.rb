require "helog/version"
require "helog/runner"
require 'helog/google_drive_mixin'
require 'helog/fetcher'
require 'helog/google_drive_uploader'

module Helog
  LOGGER_ROTATE_SIZE = ENV['ROTATE_SIZE'] || 1000 * 1024 * 1024 # 1GB

  def self.run(cmd: , logfilename: )
    Runner.new(cmd, logfilename).run
  end

  def self.fetch(dates: )
    Fetcher.new(dates: dates).run
  end
end
