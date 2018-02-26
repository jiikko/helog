require 'logger'
require 'open3'
require 'fileutils'
require 'thread'

module Helog
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
      write_pid_file
      begin
        start_cmd_thread
        start_cmd_watch_thread
        start_log_upload_thread
        loop { sleep(10) }
      ensure
        FileUtils.rm_rf(PID_PATH)
      end
    end

    def restart_cmd
      @cmd_thread.kill
      start_cmd_thread
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

    def start_cmd_thread
      @cmd_thread =
        Thread.start do
          loop do
            logging_with do |logger|
              # https://docs.ruby-lang.org/ja/latest/method/Open3/m/popen3.html
              Open3.popen2(@cmd) do |_stdin, stdout, wait_thr|
                while line = stdout.gets
                  Thread.handle_interrupt(RuntimeError => :never) do
                    logger.info line
                  end
                end
              end
              puts 'process exited. restart!'
              sleep(3)
            end
          end
        end
    end

    def logging_with(&block)
      # https://docs.ruby-lang.org/ja/latest/library/logger.html
      logger = Logger.new(@logfilename, 100, LOGGER_ROTATE_SIZE)
      logger.formatter = proc { |severity, datetime, progname, msg| msg }
      yield(logger)
    ensure
      logger.close
    end

    # FIXME アップロード対象のファイルの検出はポーリングしているが、ディレクトリを監視してもいいかも. 性能がでないなら検討する
    def start_log_upload_thread
      loop do
        # 番号が大きい順に並び替える. 番号大きいログの方が古い
        filenames = Dir.glob("#{@logfilename}.*").sort_by { |filename| - filename.split('.')[-1].to_i }
        filenames.each do |filename|
          GoogleDriveUploader.new(filename).run
        end
        sleep(1)
      end
    end

    def start_cmd_watch_thread
      t =
        Thread.start do
          puts 'start watch!'
          loop do
            logfile = File.open(@logfilename)
            sleep(4)
            if (Time.now - logfile.mtime) > 20
              puts 'restart! from cmd_watcher'
              restart_cmd
              sleep(10) # 起動時はすぐにはログを書き込まないのでちょっと待つ
            end
          end
        end
    end
  end
end
