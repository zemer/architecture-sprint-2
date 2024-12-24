# pymongo-api

Запуск

```shell
cd ./sharding-repl-cache
```

```shell
docker compose up -d
```

Заполняем mongodb данными

```shell
./scripts/mongo-init.sh
```

Проверка количества документов

```shell
./scripts/count.sh
```

## Как проверить

Откройте в браузере http://localhost:8080

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://localhost:8080/docs
