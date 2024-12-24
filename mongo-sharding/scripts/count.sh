docker compose exec -T router mongosh --port 27020 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
exit()
EOF

echo

docker compose exec -T shard1 mongosh --port 27018 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF

echo

docker compose exec -T shard2 mongosh --port 27019 --quiet <<EOF
use somedb
db.helloDoc.countDocuments()
EOF