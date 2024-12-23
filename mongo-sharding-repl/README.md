# pymongo-api

Запускаем mongodb с шардированием и приложение

```shell
docker compose up -d
```

Инициализация сервера конфигураций

```shell
docker compose exec -T configSrv mongosh --port 27017 --quiet <<EOF
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
exit();
EOF
```

Инициализация шардов

```shell
docker compose exec -T shard1-1 mongosh --port 27018 <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1-1:27018" },
        { _id : 1, host : "shard1-2:27018" },
        { _id : 2, host : "shard1-3:27018" },
      ]
    }
);
exit();
EOF
```

```shell
docker compose exec -T shard2-1 mongosh --port 27019 <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2-1:27019" },
        { _id : 1, host : "shard2-2:27019" },
        { _id : 2, host : "shard2-3:27019" }
      ]
    }
  );
exit();
EOF
```

Инициалиация роутера

```shell
docker compose exec -T router mongosh --port 27017 <<EOF
sh.addShard( "shard1/shard1-1:27018");
sh.addShard( "shard2/shard2-2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
EOF
```

Заполняем mongodb данными

```shell
./scripts/mongo-init.sh
```

Проверка количества документов в роутере

```shell
docker compose exec -T router mongosh --port 27017 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF
```

Проверка количества документов в 1 шарде

```shell
docker compose exec -T shard1-1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF
```

Проверка количества документов в 2 шарде

```shell
docker compose exec -T shard2-1 mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF
```
