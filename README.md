# ProcessWatcher
* heroku logsを実行して適宜google driveにアップロードするコマンドです
* 実行すると3つのThreadが動きます
  * heroku logsの出力をLoggerに書き込むThread
  * heroku logsコマンドの書き込みが停止しているとコマンドを再起動するThread
  * Loggerがrotateしたログをgoogle driveにアップロードするThreadの3つが動きます

## Installation
* `bundle install`
* google api の認証トークンを作成してgv_config.json にセットする
  * https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
  * `echo GoogleDrive::Session.from_config("config.json") | bin/console` やって`config.json`に認証情報を埋め込む
    * このプロセスを動かすマシン毎に実行する必要がある
    * 認証情報込の`json.config`をそのまま渡してもいいかも

## Usage
```
$ git clone https://github.com/jiikko/process_watcher
$ LOG_ROOT_DIR=app-log bin/process_watcher 'heroku logs -t --app hoge-app' logs/heroku.log
```

## TODO
* 指定した日時のログをダウンロードしてくるコマンドを作る
* 取り込んだログファイルをpapertrailのように検索できるWEBアプリを作る
* Linuxサーバ上で稼働できるようにする
  * heroku logsコマンドを実行できる必要があって認証をどうする?
* heroku log drainでログを受け取ってgoogle driveにアップロードしたい
  * 受取手のサーバは heroku のhobby でも動きそうだけどログの量が多いのでリクエストがつまりそう(やっていない)

## 完了したTODO
* google drive
  * アップロードするファイルは圧縮する
* アップロード中にファイル名が変更されると未アップロードなファイルを削除する可能性があるのでLoggerがストップしていて欲しい
  * Fiberを使ってLogginngスレッドを停止しておく？
  * https://docs.ruby-lang.org/ja/latest/class/Fiber.html
  * Loggerがrotateする頻度よりアップロードのほうがすぐに完了するので問題はないとする
  * DONE
* Loggerへの書き込みが終了した時に再起動するようにする
  * heroku logsが終了した時にrestartすること
    * オフラインにすると`ENOTFOUND: getaddrinfo ENOTFOUND api.heroku.com api.heroku.com:443`という出力がでてきてプロセスが再実行実行された
  * ファイルへの書き込みをしなくなった時にrestartすること
    * ファイルの書き込みが止まるとコマンドを再起動したのを確認
       * `restart! from cmd_watcher`と出た

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

## 保留的なメモ
* 集計する時、ログフィアルが20個ぐらいあるはずでしかも随時ファイルがアップロードされていく状況。なので随時集計をしている場合必ずしも時系列になるとは限らない、したがって、リアルタイムにスプレットシートの最新業に書き足していくことはできない(よくわからなくなってきたので後で考える)
  * google driveにアップロードしたらgoogle のなんかで集計する?
  * シートへ時系列に集計するには、集計結果のJSONを書き出しておいてすべて並び替えておき、1シートずつ並列でアップロードをしていく

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
