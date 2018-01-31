require "process_watcher/version"
require "process_watcher/runner"

module ProcessWatcher
  def self.run(heroku_app_name: , logfilename: )
    Runner.new(heroku_app_name, logfilename).run
  end
end
