require 'logger'
require 'open3'
require 'fileutils'
require 'google_drive_uploader'

module ProcessWatcher
  class Runner
    PID_PATH = 'tmp/pid'

    def initialize(cmd, logfilename)
      if logfilename.nil?
        raise '書き込むファイルがない'
        exit 1
      else
        FileUtils.touch(logfilename)
      end
      @logfilename = logfilename
      @cmd = cmd
    end

    def run
      # プロセスを停止したタイミングによってファイルが上書きされるタイミングはないか？
      write_pid_file
      start_cmd
      start_cmd_watcher
      upload_to_google_drive
      loop { sleep(1) }
    ensure
      FileUtils.rm_rf(PID_PATH)
    end

    def restart_cmd
      @cmd_thread.kill
      start_cmd
    end

    private

    def write_pid_file
      if File.exists?(PID_PATH)
        raise '既に起動中のようです'
        exit 1
      else
        File.write(PID_PATH, Process.pid)
      end
    end

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
      per_size = 400 * 1024 * 1024 # 400 MB
      logger = Logger.new(@logfilename, 100, per_size) # https://docs.ruby-lang.org/ja/latest/library/logger.html
      logger.formatter = proc { |severity, datetime, progname, msg| msg }
      yield(logger)
    ensure
      logger.close
    end

    # Loggerがrotateしたログファイルをgoogle driveにアップしていく
    def upload_to_google_drive
      loop do
        # 番号が大きい順に並び替える
        filenames = Dir.glob("logs/heroku.log.*").sort_by { |filename| - filename.split('.')[-1].to_i } }
        filenames.each do |filename|
          GoogleDriveUploader.new(filename).run
        end
        sleep(1)
      end
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
