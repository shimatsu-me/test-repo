## テスト実行

テーブルを作り直してからテスト実行。

使っているシェルによっては rake 実行時に怒られるので以下のチェックしてテーブルを作り直してください

- bash を使用している場合

```bash
docker-compose exec -e RACK_ENV=test web bundle exec rake db:migrate[0] &&
docker-compose exec -e RACK_ENV=test web bundle exec rake db:migrate &&
docker-compose exec -e RACK_ENV=test web bundle exec parallel_rspec
```

- zsh を使用している場合

```zsh
docker-compose exec -e RACK_ENV=test web bundle exec rake 'db:migrate[0]' &&
docker-compose exec -e RACK_ENV=test web bundle exec rake db:migrate &&
docker-compose exec -e RACK_ENV=test web bundle exec parallel_rspec
```

行数指定のテスト実行

```bash
docker-compose exec -e RACK_ENV=test web bundle exec rspec spec/domain/repository/restaurant_repository_spec.rb:1006
```

## Rubocop 実行

Ç

### 違反の部分を.rubocop_todo.yml に記録する

`docker-compose exec web bundle exec rubocop --auto-gen-config`

### 違反の部分を自動で修正

`docker-compose exec web bundle exec rubocop -a`

## migration 手動実行

`docker-compose exec -e RACK_ENV=development web bundle exe rake db:migrate`

### バージョンを指定して実行

`VERSION` は `migrations` のファイル名の先頭の数字文字列のこと。

`docker-compose exec -e RACK_ENV=development web bundle exe rake db:migrate[VERSION]`

初期状態（何もテーブルがない状態）にリセットするには `VERSION` を `0` で実行

## 開発、テスト環境向け初期データ登録

対象のテーブルが空のときのみ insert する

### Restaurant（レストラン）用の初期データ

`docker-compose exec -e RACK_ENV=development web bundle exec rake db:initialdata`

### Photo Studio（フォトスタジオ）用の初期データ

`docker-compose exec -e RACK_ENV=development web bundle exec rake db:photo_initialdata`

### zsh で migration を手動実行

- zsh で migration を手動実行する場合には、`zsh: no matches found: db:migrate[VERSION]`というエラーが発生します
  - その場合は rake コマンド以下をシングルクウォートで囲むと実行できます
  - `docker-compose exec -e RACK_ENV=development web bundle exec rake 'db:migrate[VERSION]'`

# Migration について

## ルール

- `/db/migrations` 以下に migration ファイルを保存
- ファイル名は `XXYYYYMMDDHHMMSS_〜.rb`
  - `YYYYMMDDHHMMSS` は作成日時の年月日時分秒の 14 桁
  - `XX`は作成日時をミスしたために日付調整する値を追加した
  - 先頭の数字文字列がバージョンになるので、時系列に昇順にならないといけない。
- ダウングレードの処理も必ず書く

### 参考

[migration.rdoc](http://sequel.jeremyevans.net/rdoc/files/doc/migration_rdoc.html)
