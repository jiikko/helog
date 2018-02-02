require "google_drive"
require 'date'

# Loggerがrotateしたログファイルをgoogle driveにアップしていく
module ProcessWatcher
  class GoogleDriveUploader
    LOG_ROOT_DIR = ENV['LOG_ROOT_DIR']

    # フォルダをゴミ箱に移動してもfolders_by_nameでヒットするので完全に削除しなければならない
    #
    # ログ・ファイルは下記レイアウトで保存をする
    # root - app-log - 2016
    #                          \- 2017
    #                          \- 2018
    #                                \--- 01
    #                                  |  \- 01-0.gz
    #                                  |  |- 01-1.gz
    #                                  |  |- 01-2.gz
    #                                  |  \- 01-3.gz
    #                                  \- 02
    #                                     \- 01-0.gz
    #                                     |- 01-1.gz
    #                                     |- 01-2.gz
    #                                     \- 01-3.gz

    def initialize(filename)
      @filename = filename
    end

    # TODO 接続情報はキャッシュしておく
    def run
      session = GoogleDrive::Session.from_config("gv_config.json")
      log_folder = session.folders_by_name(LOG_ROOT_DIR)
      if log_folder.nil?
        log_folder = session.root_folder.create_subcollection(LOG_ROOT_DIR)
      end

      today = Date.today
      current_year = today.strftime('%Y')
      current_month = today.strftime('%m')
      current_day = today.strftime('%d')

      year_folder = log_folder.subfolder_by_name(current_year)
      if year_folder.nil?
        year_folder = log_folder.create_subcollection(current_year)
      end
      month_folder = year_folder.subfolder_by_name(current_month)
      if month_folder.nil?
        month_folder = year_folder.create_subcollection(current_month)
      end
      # MEMO ログファイルが1日に100個以上できるとページネーションしないといけない
      log_files = month_folder.files(q: "name contains '#{current_day}'")
      max_num = (log_files.map{ |x| %r!-(\d+)\.log! =~ x.title; $1 }.map(&:to_i).max + 1) || 0
      month_folder.upload_from_file(@filename, "#{current_day}-#{max_num}.log")
      remove
    end

    private

    def remove
      FileUtils.rm_rf(@filename)
    end
  end
end
