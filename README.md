# ruby ddd

## Get Starting

<code>
bundle exec rackup config.ru
</code>

## 各層（ディレクトリ）の説明

## presentation 層

### handler

ルーティングと入出力を扱う。
入力値のバリデーションも必須項目と型が合ってるか位はここで扱います

## usecase 層

### usecase

domain 層とクエリサービスの機能を組み合わせて、アクターのユースケース(アクション)を実現する。組み合わせるだけなので基本的に薄い実装になります。
１アクター１ユースケースなので、現在は１クライアントアプリ１ユースケースで実装しています。

### query service

コマンドクエリ分離（CQRS）をしているので、参照系の処理はこのファイルで扱います。
１ユースケース、１クエリサービスとしています。

## domain 層

### model

ビジネスロジックを詰め込んだファイル。
domain model だけを確認すれば、どんなビジネスルールが存在するか理解できるように実装する。
また完全コンストラクタとしているので、常に不変で有ることと、
インスタンス化されてから消えるまで、常に正しく有り続けます。

### value object

値オブジェクト。リポジトリ関連の値を担当するオブジェクトになります。
リポジトリ関連のバリデーションはこのファイルに全て実装します。
テーブルのプロパティではなく、あくまで値である事に注意してください。
値オブジェクトもまた、完全コンストラクタになります。

### repository

技術的関心事を詰め込んだファイル。DB 登録、メール送信等、
技術的且つ具体的な処理はこのファイルに実装します。
また、集約としても機能させているので、1 集約 1 リポジトリとなっています。

### domain service

ドメインロジックではあるが、他の domain 層に置き場所がない処理を担当します。
便利ではありますが、基本的にはモデルや値オブジェクトに実装できないか、
良く考えてから使用してください。
また、１リポジトリ１ドメインサービスで実装してください。

## 補足説明

### レイヤードアーキテクチャ

このアプリケーションはレイヤードアーキテクチャを意識して作られています。
各層の依存関係は、presentation → usecase → domain/repository → domain/model
となっています。

### 集約パターン

1repository 1 集約。
集約とは、各モデルをトランザクション境界で区切ってまとめた物になります。
簡単に言うとデータの整合性を担保したいまとまりになります。
＊1table 1 集約ではありません。

### CQRS パターン

CRUD の R（クエリ）と CUD（コマンド）を明確に分けて実装するパターンになります。
コマンドは集約としてリポジトリから、クエリはクエリサービスに実装して下さい。

# 開発環境

開発環境用.env

## ビルド

`docker-compose build`

## 起動

`docker-compose up -d`

### ビルドしつつ起動

`docker-compose up -d --build`

## 再起動

`docker-compose restart`

## 終了

`docker-compose down`

## コンテナに入る

### web

`docker-compose exec web bash`

### db

`docker-compose exec db bash`

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

# Mail

## Mailcatcher

開発環境のみ

http://localhost:1080/

# 環境変数について

環境変数を追加した場合に以下のファイルの設定変更が必要かもです。

```
ibj_reserve/cfn-ecs.yml
ibj_reserve/docker-compose.yml
ibj_reserve/.github/workflows/deploy_staging.yml
ibj_reserve/.github/workflows/ruby.yml
ibj_reserve/deploy/deploy.sh
ibj_reserve/deploy/taskdef.json.staging

# 開発環境のみ
ibj_reserve/.env
```

また Github での環境変数追加設定も必要です。

`Settings -> Secrets -> Actions` から `New repository secret` で追加。

# RSpec について

## 下記テンプレートについて

- 実際に書くテストによってテンプレートの文言などは調整をお願いします。

```
# frozen_string_literal: true

require ''

RSpec.describe Class名 do
  context '#メソッド名' do
    context '〇〇の場合' do
      it '〇〇を〇〇できる' do
        expect()
      end
    end
  end
end
```

## Git Commit Guidelines（IBR）

### Guidelines の目的

**① コード変更意図の早期理解（未来の実装者/運用者のため）**

- コードの変更意図をわかりやすく伝えることができる

**② レビュー時間の短縮（レビュワーのため）**

- コードの変更意図をわかりやすく伝えることができる

**③push 後のコミットの変更の容易化（実装者/自分のため）**

- push 後に変更があった場合、revert して修正するのが簡単になる

### コミット時の Point

- コミットの粒度を小さくする
- コミットメッセージに接頭辞をつける
- コミットメッセージには、「対象」と「動詞」を含める
- コミットメッセージには、「何のために」を含める
- コミットメッセージは、端的に

#### コミットの粒度を小さくする

```
【悪い例】
- 1つのコミットに、複数機能や関連がない複数箇所の修正を含める

【良い例】
- 1つのコミットには、1つの機能や1つの修正を含める

【修正理由】
- コードの変更意図がわからなくなってしまう
```

#### コミットメッセージに接頭辞をつける

[Add]: 新機能や新しいファイルの追加
[Update]: 既存の機能の変更や修正
[Fix]: バグ修正
[Remove]: 不要なコードやファイルの削除
[Refactor]: コードのリファクタリング
[Test（or Rspec）]: テストコードの追加や修正
[Docs]: ドキュメントの変更
[Chore（or Config）]: ビルドプロセスや設定ファイルの変更

```
【悪い例】
ログイン画面の修正

【良い例】
[Fix]ログイン画面の修正
→バグ修正だと一目でわかる。

[Update]ログイン画面の修正
→既存機能を新しいものに変更・修正したことが一目でわかる。

【修正理由】
- レビュワーがコミットの意図を理解するまで時間がかかってしまう。
```

#### コミットメッセージには、「対象」と「動詞（or 動詞の名詞 ver.）」を含める

```
【悪い例】
[Fix]修正

【良い例】
[Fix]ログイン機能の修正
→対象は「ログイン機能」、動詞は「修正」。

【修正理由】
- レビュワーがどのコミットから読めば良いのか判断する時間がかかってしまうため。1つ1つのコミットを確認しなければいけない。
```

#### コミットメッセージには、「何のために（コードの変更意図）」を含める

```
【悪い例】
[Fix]ログイン機能の修正

【良い例】
[Fix]正しくログインできるように、ログイン機能を修正

【修正理由】
- 「何のために」修正をしたかをコミットメッセージに含めることで、実装者の意図をレビュワーが素早く理解することができます。
```

#### コミットメッセージは、端的に

```
【悪い例】
[Fix]ユーザーがログインできない原因箇所を修正し、正しくログインできるようにログイン機能を修正

【良い例】
[Fix]正しくログインできるように、ログイン機能を修正

【修正理由】
- 長いコミットメッセージは、レビュー者を混乱させたり、レビュー時間の増加につながるため、端的なコミットを心がけましょう。
- 変更前の状態はコードを読めばわかるため、修正後・変更後の状態のみを書くのが良いです。
- コミットメッセージが長くなる場合は、コミットの粒度を小さくすることを検討しましょう。
```
