#!/bin/bash

cd /opt/postgres_docker

case "$1" in
  start)
    echo "🚀 Iniciando PostgreSQL..."
    docker-compose up -d
    ;;
  stop)
    echo "🛑 Parando PostgreSQL..."
    docker-compose down
    ;;
  restart)
    echo "🔄 Reiniciando PostgreSQL..."
    docker-compose restart
    ;;
  status)
    docker-compose ps
    ;;
  logs)
    docker-compose logs -f --tail=100
    ;;
  backup)
    ./backup.sh
    ;;
  restore)
    if [ -z "$2" ]; then
      echo "Uso: $0 restore <arquivo_backup.sql>"
      exit 1
    fi
    echo "⚠️  Restaurando backup: $2"
    docker exec -i postgres_shared psql -U admin < "$2"
    ;;
  shell)
    docker exec -it postgres_shared psql -U admin
    ;;
  create-db)
    if [ -z "$2" ]; then
      echo "Uso: $0 create-db <nome_do_banco>"
      exit 1
    fi
    echo "📦 Criando banco: $2"
    docker exec -it postgres_shared psql -U admin -c "CREATE DATABASE $2;"
    ;;
  list-dbs)
    docker exec -it postgres_shared psql -U admin -l
    ;;
  *)
    echo "Gestor do PostgreSQL"
    echo ""
    echo "Uso: $0 {start|stop|restart|status|logs|backup|restore|shell|create-db|list-dbs}"
    echo ""
    echo "Comandos:"
    echo "  start       - Iniciar o PostgreSQL"
    echo "  stop        - Parar o PostgreSQL"
    echo "  restart     - Reiniciar o PostgreSQL"
    echo "  status      - Ver status do container"
    echo "  logs        - Ver logs em tempo real"
    echo "  backup      - Executar backup manual"
    echo "  restore     - Restaurar backup (arquivo.sql)"
    echo "  shell       - Acessar console do PostgreSQL"
    echo "  create-db   - Criar novo banco de dados"
    echo "  list-dbs    - Listar todos os bancos"
    exit 1
    ;;
esac