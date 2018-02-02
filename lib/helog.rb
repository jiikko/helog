require "helog/version"
require "helog/runner"
require 'helog/google_drive_uploader'

module Helog
  LOGGER_ROTATE_SIZE = 400 * 1024 * 1024 # 400 MB

  def self.run(cmd: , logfilename: )
    Runner.new(cmd, logfilename).run
  end
end
