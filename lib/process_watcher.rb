require "process_watcher/version"
require "process_watcher/runner"
require 'process_watcher/google_drive_uploader'

module ProcessWatcher
  LOGGER_ROTATE_SIZE = 400 * 1024 * 1024 # 400 MB

  def self.run(cmd: , logfilename: )
    Runner.new(cmd, logfilename).run
  end
end
