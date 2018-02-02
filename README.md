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
* google drice
  * 今日の日付のディレクトリにアップロードすること
  * アップロードしたファイルの添字が最後+1になっていること
  * アップロードするファイルは圧縮する
* 動作確認
  * heroku logsが終了した時にrestartすること
  * ファイルへの書き込みをしなくなった時にrestartすること

## 動作上のメモ
* 日付に関係なく、常に同名logfileに書き出していて、別スレッドで常にgoogle driveに現在に日付へアップロードを行う
  * アップロードが滞るとlogfileが3日間とかのログファイルが0..30くらい溜まってすべて同日にアップロードされる
    * こうならないためにアップロードは常に成功しなければならない
* google drive へのアップロードは、
  * drive上にある日付ディレクトリの最大添字+1にしたファイル名にして保存していく
  * ログファイルにある数字の小さいファイルの添字からアップロードしていく
  * アップロードを完了にするファイル名はそのままにしておいて、アップロードが完了したファイルにはnull文字を書き出す
* ruby loggerは、ローテイトするごとにファイル名の添字をインクリメントする
  * ローテイトして分割ファイル数を超えると添字の大きいファイルから削除を行う
* ログファイルが5個あってアップロードを2/5完了している時にプロセスをrestartしたら、null文字を書き込む前の2/5目を再び再アップロードする可能性がある

## 保留的なメモ
* 集計する時、ログフィアルが20個ぐらいあるはずでしかも随時ファイルがアップロードされていく状況。なので随時集計をしている場合必ずしも時系列になるとは限らない、したがって、リアルタイムにスプレットシートの最新業に書き足していくことはできない(よくわからなくなってきたので後で考える)
  * google driveにアップロードしたらgoogle のなんかで集計する?
  * シートへ時系列に集計するには、集計結果のJSONを書き出しておいてすべて並び替えておき、1シートずつ並列でアップロードをしていく

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
