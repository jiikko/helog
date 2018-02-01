require "process_watcher/version"
require "process_watcher/runner"

module ProcessWatcher
  def self.run(cmd: , logfilename: )
    Runner.new(cmd, logfilename).run
  end
end
