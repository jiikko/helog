module Helog
  module GoogleDriveMixin
    # フォルダをゴミ箱に移動してもfolders_by_nameでヒットするので完全に削除しなければならない
    #
    # ログ・ファイルは下記レイアウトで保存をする
    # root - app-log - 2016
    #               \- 2017
    #               \- 2018
    #                     \--- 01
    #                       |  \- 01-0.gz
    #                       |  |- 01-1.gz
    #                       |  |- 01-2.gz
    #                       |  \- 01-3.gz
    #                       \- 02
    #                          \- 01-0.gz
    #                          |- 01-1.gz
    #                          |- 01-2.gz
    #                          \- 01-3.gz

    private

    def session
      @session ||= GoogleDrive::Session.from_config("gv_config.json")
    end
  end
end
