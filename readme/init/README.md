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
