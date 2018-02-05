# Provisioning
* helog をmacOS内のVMで動かす手順を書いています

## インストール
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew cask install virtualbox
brew cask install vagrant
cd ~/helog/provisioning
vagrant up
```

#### heroku へのログイン
```
bundle exec cap helog login heroku
```

## 起動
```
bundle exec cap helog start
```

## macOS起動時にVMを起動する方法
TODO

## メモ
* VMはホストオンリーアダプタで起動し、macOSのホスト名で名前解決してアクセスする
  * VMにいれるミドルウェアを減らせるから
