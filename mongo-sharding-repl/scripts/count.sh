docker compose exec -T router mongosh --port 27017 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

echo

docker compose exec -T shard1-1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

echo

docker compose exec -T shard1-2 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

echo

docker compose exec -T shard1-3 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

echo

docker compose exec -T shard2-1 mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

echo

docker compose exec -T shard2-2 mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

echo

docker compose exec -T shard2-3 mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF