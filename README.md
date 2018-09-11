# Helog(heroku + log)
* heroku logsを実行して適宜google driveにアップロードするコマンドです

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

## 動作上のメモ
* google drive へのアップロードは
  * drive上にある日付ディレクトリの最大添字+1にしたファイル名にして保存していく
  * ログファイルにある数字の大きいファイルの添字からアップロードしていく
  * アップロードが完了したらそのファイルを削除する
* loggerが作るログファイルが大量にある時はアップロードに失敗している
  * 正常にアップロードができていたらそのログファイルは最新のぶんのみになっているはず

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
