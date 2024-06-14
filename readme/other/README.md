## Get Starting

<code>
bundle exec rackup config.ru
</code>

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

# Mail

## Mailcatcher

開発環境のみ

http://localhost:1080/
