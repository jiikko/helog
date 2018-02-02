# ProcessWatcher
* heroku logsを実行して適宜google driveにアップロードするコマンドです

## Installation
`bundle install`

## Usage
```
$ git clone https://github.com/jiikko/process_watcher
$ bin/process_watcher 'heroku logs -t --app hoge-app' logs/heroku.log
```

## TODO
* tmp/pid を作成して二重起動しないようにする
* launchdのplist作ってmacoxのserviceとして稼働できるようにする
* 日付が変わるかわったら前日分が当時にアップロードされるだろう
* google drice へ送信する時は圧縮する

## 動作上のメモ
* 日付に関係なく、常に同名logfileに書き出していて、別スレッドで常にgoogle driveに現在に日付へアップロードを行う
  * アップロードが滞るとlogfileが3日間とかのログファイルが0..30くらい溜まってすべて同日にアップロードされる
    * こうならないためにアップロードは常に成功しなければならない

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
