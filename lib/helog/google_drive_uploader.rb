require "google_drive"
require 'date'

# Loggerがrotateしたログファイルをgoogle driveにアップしていく
module Helog
  LOG_ROOT_DIR = ENV['LOG_ROOT_DIR'] || 'app_log'

  class GoogleDriveUploader
    include Helog::GoogleDriveMixin

    def initialize(filename)
      @filename = filename
      @current_date = Date.today
    end

    def run
      # ログファイルが1日に100個以上できるとページネーションしないといけない
      upload
    rescue => e
      puts e.full_message
      sleep(5)
      retry
    end

    def max_num_of_files
      max = (log_files.map{ |x| %r!-(\d+)\.log! =~ x.title; $1 }.map(&:to_i).max)
      if max.nil?
        0
      else
        max + 1
      end
    end

    private

    def upload
      # retry するとgzip済みで元ファイルが消えているため存在確認をする
      Open3.popen2("gzip #{@filename}") if File.exists?(@filename)
      month_folder.upload_from_file("#{@filename}.gz", "#{current_day}-#{max_num_of_files}.log.gz")
      FileUtils.rm_rf("#{@filename}.gz")
    end

    def log_files
      month_folder.files(q: "name contains '#{current_day}'")
    end

    def current_year
      current_year = @current_date.strftime('%Y')
    end

    def current_month
      current_month = @current_date.strftime('%m')
    end

    def current_day
      current_day = @current_date.strftime('%d')
    end
  end
end
