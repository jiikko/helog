# Helog(heroku + log)
* heroku logsを実行して適宜google driveにアップロードするコマンドです
* 実行すると3つのThreadが動きます
  * heroku logsの出力をLoggerに書き込むThread
  * heroku logsコマンドの書き込みが停止しているとそのThreadを再起動するThread
  * Loggerがrotateしたログをgoogle driveにアップロードするThread

## Installation
* `bundle install` && `cp gv_config.sample.json gv_config.json` && `bin/setup_google_drive`
  * google driveへのアクセス権限を取得する

### google api のトークンを発行する(初回のみ)
* 下記を参照しトークンを作成してgv_config.json にセットする
  * https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md

## Usage
```
$ git clone https://github.com/jiikko/helog
$ LOG_ROOT_DIR=app-log bin/helog 'heroku logs -t --app hoge-app' logs/heroku.log
```

## TODO
* 取り込んだログファイルをpapertrailのように検索できるWEBアプリを作る
* どこかで継続してエラーがおきたらslackに通知する

## 動作上のメモ
* 日付に関係なく、常に同名logfileに書き出していて、別スレッドで常にgoogle driveに現在に日付へアップロードを行う
  * アップロードが滞るとlogfileが3日間とかのログファイルが0..30くらい溜まってすべて同日にアップロードされる
    * こうならないためにアップロードは常に成功しなければならない
* google drive へのアップロードは
  * drive上にある日付ディレクトリの最大添字+1にしたファイル名にして保存していく
  * ログファイルにある数字の大きいファイルの添字からアップロードしていく
  * アップロードが完了したらそのファイルを削除する
* ruby loggerは、ローテイトするごとにファイル名の添字をインクリメントする
  * ローテイトして分割ファイル数を超えると添字の大きいファイルから削除を行う
* loggerが作るログファイルが大量にある時はアップロードに失敗していることを意味してる
  * 正常にアップロードができていたらそのログファイルは最新のぶんのみになっているはず

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
