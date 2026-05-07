#!/bin/bash

echo "=== Status do PostgreSQL ==="
docker ps --filter "name=postgres_shared" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "=== Uso de Disco ==="
du -sh /opt/postgres_docker/pgdata

echo ""
echo "=== Conexões Ativas ==="
docker exec postgres_shared psql -U admin -c "SELECT count(*) FROM pg_stat_activity;"

echo ""
echo "=== Tamanho dos Bancos ==="
docker exec postgres_shared psql -U admin -c "
SELECT 
    datname as database,
    pg_size_pretty(pg_database_size(datname)) as size
FROM pg_database 
ORDER BY pg_database_size(datname) DESC;
"