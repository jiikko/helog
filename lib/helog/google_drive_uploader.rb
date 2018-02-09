require "google_drive"
require 'date'

# Loggerがrotateしたログファイルをgoogle driveにアップしていく
module Helog
  LOG_ROOT_DIR = ENV['LOG_ROOT_DIR'] || 'app_log'

  class GoogleDriveUploader
    include Helog::GoogleDriveMixin

    def initialize(filename)
      @filename = filename
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
      -> { Date.today.strftime('%Y') }.call
    end

    def current_month
      -> { Date.today.strftime('%m') }.call
    end

    def current_day
      -> { Date.today.strftime('%d') }.call
    end

    def month_folder
      log_folder = session.folders_by_name(Helog::LOG_ROOT_DIR)
      if log_folder.nil?
        log_folder = session.create_subcollection(Helog::LOG_ROOT_DIR)
      end
      year_folder = log_folder.subfolder_by_name(current_year)
      if year_folder.nil?
        year_folder = log_folder.create_subcollection(current_year)
      end
      month_folder = year_folder.subfolder_by_name(current_month)
      if month_folder.nil?
        month_folder = year_folder.create_subcollection(current_month)
      end
      month_folder
    end
  end
end
