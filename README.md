# 各 README のパス

- [環境構築](/readme/setup/README.md)
- [コマンド](/readme/cmd/README.md)
- [テスト](/readme/test/README.md)
- [Git](/readme/git/README.md)
- [DDD](/readme/ddd/README.md)
- [その他](/readme/other/README.md)

# 【IBR\_飲食】リポジトリとサービス仕様のミニマムガイド（+運用ドキュメント）

## リポジトリ管理とテーブルチェック連携の図

以下の図は、「IBR\_飲食」のフロントエンドとバックエンドのコードが、どのリポジトリで管理されているかを視覚的にわかりやすくした図です。各コードを管理しているリポジトリ名（repo）と、フロントエンドが使用している API のエンドポイント名（endpoint）を記載しています。

また、予約システム API が、TableCheck API を利用していることを示しています。

※予約システム API がフォトでも使用されていることを示すため、以下の図にはフォトのリポジトリも掲載しています。

<img width="515" alt="Screenshot 2024-06-24 at 15 42 34" src="https://github.com/shimatsu-me/test-repo/assets/155062610/55048e8e-13c5-4851-9d17-14f14d10ed38">

リポジトリ（GitHub）：https://github.com/ibj-labo

# サービス概要

- IBR は、「web（飲食）」「photo」「omiai」の 3 つの管理システムがある

※「omiai」は近々停止予定のため、ほとんど稼働していない。

- 「web（飲食）」には、「ToC 画面」「本部管理画面」「店舗管理画面」の 3 つの画面がある
- 「web（飲食）」と「photo」は、バックエンド（API）を共通で使用している
- 「ToC 画面」に店舗を表示するためには、「本部管理画面」で、店舗に「利用サービス登録」を行う必要がある
- 「web（飲食）」でユーザーが予約する際の「予約の種類」は、リクエスト予約と即時予約がある
  - リクエスト予約：IBR システムを使用した予約（IBR の予約 API を使用して予約します）
  - 即時予約：TableCheck の予約システムを使用した予約（TableCheck API を使用して予約します）

# 主要仕様のミニマム業務フロー図

## 「主要仕様」とは

エンジニアが IBR\_飲食の開発に携わるときに、事前に知っておかなければ、開発をスムーズに進められない仕様のこと。

### 例：利用サービス登録

「IBR 本部管理画面＞利用サービス登録」で店舗に利用サービスを登録しておかないと、ToC 画面に店舗が表示されない。

## 管理者フロー

[利用サービス登録 ON/OFF → 店舗の表示/非表示](https://cacoo.com/diagrams/OGeJeuKk4NiMlk69/69385)

[店舗の予約種類の変更（リクエスト予約/即時予約/アフィリエイト予約）](https://cacoo.com/diagrams/BSIOCkyXLooNFz6C/A5658)

[「2 軒目デート」タグ](https://cacoo.com/diagrams/ia26Nv6c3IQgIC1H/4D1BC)

## ユーザーフロー

店舗の予約種類の変更（リクエスト予約/即時予約/アフィリエイト予約）

診断コンテンツ

[リクエスト予約]店舗の詳細から web 予約

[リクエスト予約]店舗の詳細から電話予約 ※「集客強化店舗」（ibj_reserve で管理）のみ電話予約可

[TableCheck 予約]店舗の詳細 →TC サイトで予約

[アフィリエイト予約]店舗一覧 → 各予約サイトで予約

# **開発・運用環境**

- 開発、テスト、ステージング、本番環境の構成
  - ローカル環境：自身の PC で立ち上げる
  - ステージング環境：以下「各サービスの URL」を参照
  - 本番環境：以下「各サービスの URL」を参照

### 各サービスの URL

[IBR URL -web-](https://www.notion.so/IBR-URL-web-bf013df3eeff4dfdb26eb2ec9ae273f7?pvs=21)

[IBR URL -restaurant-](https://www.notion.so/IBR-URL-restaurant-78d37d1985a545899ae486f623603be6?pvs=21)

[IBR URL -photo-](https://www.notion.so/IBR-URL-photo-12001b7978c64ca5bdf5d14dab84b490?pvs=21)

[IBR URL -お見合いラウンジ-](https://www.notion.so/IBR-URL-9501fd3482004653a0934fe561e7e475?pvs=21)

### 環境構築とリリース手順

[【IBR\_飲食】環境構築とリリース手順](https://www.notion.so/IBR_-42c9d90984754d069a0643f50621b9b6?pvs=21)

# **プロジェクト管理**

- スケジュールやマイルストーン
  - プロジェクト管理ツール（Notion）：[予約システム](https://www.notion.so/320457b1d5b7448d9fcbd21590a15b27?pvs=21)
- リスク管理と対応策
  - 振り返り（バグ対応）：[](https://www.notion.so/60a3eec9049a4d6f9a63216795b2eff6?pvs=21)
  - ポストモーテム（障害対応）：[💚 ポストモーテム](https://www.notion.so/1f446050c5934db2a123da47df954458?pvs=21)
- 役割分担と責任者
  - タスク起票：ディレクター、開発者
  - タスク進捗管理：ディレクター

# **テスト計画**

- テスト方法：Excel にまとめたテストケースに基づきテストを実施
- 品質基準と合格基準：開発者とディレクターのテスト実施結果が全て OK の場合、テスト合格

## テストケースを管理する Excel ファイル

[https://ibjapan.sharepoint.com/sites/IBJShareDrive/Shared Documents/Forms/AllItems.aspx?ct=1717994042372&or=Teams-HL&ga=1&id=%2Fsites%2FIBJShareDrive%2FShared Documents%2FDrive\_制作開発マーケティング部%2FIBR&viewid=1ec4ae1f-8544-4e2d-8f40-0f6ad5680875](https://ibjapan.sharepoint.com/sites/IBJShareDrive/Shared%20Documents/Forms/AllItems.aspx?ct=1717994042372&or=Teams%2DHL&ga=1&id=%2Fsites%2FIBJShareDrive%2FShared%20Documents%2FDrive%5F%E5%88%B6%E4%BD%9C%E9%96%8B%E7%99%BA%E3%83%9E%E3%83%BC%E3%82%B1%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0%E9%83%A8%2FIBR&viewid=1ec4ae1f%2D8544%2D4e2d%2D8f40%2D0f6ad5680875)

## [試用中]テストケースを管理する Notion

https://www.notion.so/49c32953850747f88fcb7e975da886c0?pvs=21
