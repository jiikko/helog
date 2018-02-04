module Helog
  module GoogleDriveMixin
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

    private

    def session
      @session ||= GoogleDrive::Session.from_config("gv_config.json")
    end

    def month_folder
      log_folder = session.folders_by_name(LOG_ROOT_DIR)
      if log_folder.nil?
        log_folder = session.create_subcollection(LOG_ROOT_DIR)
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
