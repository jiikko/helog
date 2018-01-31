require 'logger'
require 'open3'

module ProcessWatcher
  class Runner
    def initialize(heroku_app_name, logfilename)
      @logfilename = logfilename
      @cmd = "heroku logs -t --app #{heroku_app_name}"
    end

    def run
      start_cmd_watcher
      start_cmd
    end

    def restart_cmd
      @cmd_thread.kill
      start_cmd
    end

    private

    def start_cmd
      @cmd_thread =
        Thread.start do
          loop do
            with_logging do |logger|
              # https://docs.ruby-lang.org/ja/latest/method/Open3/m/popen3.html
              Open3.popen2(@cmd) do |_stdin, stdout, wait_thr|
                while line = stdout.gets
                  logger.info line
                end
              end
            end
          end
        end
    end

    def with_logging(&block)
      logger = Logger.new(@logfilename, 10, 102400)
      logger.formatter = proc { |severity, datetime, progname, msg| msg }
      yield(logger)
    ensure
      logger.close
    end

    def start_cmd_watcher
      logfile = File.open(@logfilename)
      t =
        Thread.start do
          prev_time = Time.now
          loop do
            if prev_time == logfile.mtime
              restart_cmd
              sleep(10) # 起動時はすぐにはログを書き込まないのでちょっと待つ
            end
            sleep(4)
            prev_time = Time.now
          end
        end
    end
  end
end
