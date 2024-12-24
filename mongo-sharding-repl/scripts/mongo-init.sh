#!/bin/bash

echo "Инициализация configSrv"

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

echo
echo "Инициализация shard1"

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

echo
echo "Инициализация shard2"

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

echo
echo "Инициализация router"

docker compose exec -T router mongosh --port 27017 <<EOF
sh.addShard( "shard1/shard1-1:27018");
sh.addShard( "shard2/shard2-2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
EOF

###
# Инициализируем бд
###

echo

docker compose exec -T router mongosh --port 27017 --quiet <<EOF
use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i});
exit();
EOF