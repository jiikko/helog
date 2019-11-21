# Helog(heroku + log)
* heroku logsを実行して適宜google driveにアップロードするコマンドです

## Installation

```
$ bundle install

# google drive apiのアクセストークンを取得するためのコマンド。画面に従って認証してください。
$ bin/setup_google_drive
```

### google driveのapiを使うためのプロジェクト作成する(初回のみ)
https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md

## Usage
```
$ git clone https://github.com/jiikko/helog
$ LOG_ROOT_DIR=app-log bin/helog 'heroku logs -t --app hoge-app' logs/heroku.log
```

## 仕様
信頼はかなり悪いです。  
というのもheroku logsコマンド実行中に接続が切れているのかログが落ちてこなくなることがあり、n秒ログファイルに書き込みがなかったらThreadを再起動しているからです。

## 動作上のメモ
* google drive へのアップロードは
  * drive上にある日付ディレクトリの最大添字+1にしたファイル名にして保存していく
  * ログファイルにある数字の大きいファイルの添字からアップロードしていく
  * アップロードが完了したらそのファイルを削除する
* loggerが作るログファイルが大量にある時はアップロードに失敗している
  * 正常にアップロードができていたらそのログファイルは最新のぶんのみになっているはず

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
