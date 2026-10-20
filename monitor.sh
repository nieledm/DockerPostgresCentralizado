#!/bin/bash

# Carrega as variáveis do .env (se existir)
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

DB_USER=${POSTGRES_USER:-postgres}
DB_NAME=${POSTGRES_DB:-postgres}

echo "=== Status do PostgreSQL ==="
docker ps --filter "name=postgres_shared" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "=== Uso de Disco (pgdata) ==="
sudo du -sh /opt/postgres_docker/pgdata

echo ""
echo "=== Conexões Ativas ==="
docker exec postgres_shared psql -U "$DB_USER" -d "$DB_NAME" -c "SELECT count(*) FROM pg_stat_activity;"

echo ""
echo "=== Tamanho dos Bancos ==="
docker exec postgres_shared psql -U "$DB_USER" -d "$DB_NAME" -c "
SELECT 
    datname as database,
    pg_size_pretty(pg_database_size(datname)) as size
FROM pg_database 
ORDER BY pg_database_size(datname) DESC;
"