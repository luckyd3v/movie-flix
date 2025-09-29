#!/bin/bash
set -e

# Uso:
# scripts/load_into_db.sh [DB_HOST] [DB_PORT] [DB_NAME] [DB_USER] [DB_PASSWORD] [DATA_DIR]
# Exemplo (local/docker-compose): ./scripts/load_into_db.sh db 5432 movieflix_dw postgres postgres ./data_lake

DB_HOST=${1:-localhost}
DB_PORT=${2:-5432}
DB_NAME=${3:-movieflix_dw}
DB_USER=${4:-postgres}
DB_PASSWORD=${5:-postgres}
DATA_DIR=${6:-./data_lake}

export PGPASSWORD=$DB_PASSWORD

echo "Conectando em $DB_HOST:$DB_PORT, db=$DB_NAME"

# criar schema/tabelas (executa o SQL embedded)
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME <<'SQL'
CREATE SCHEMA IF NOT EXISTS dw;

CREATE TABLE IF NOT EXISTS dw.movies (
  imdb_id TEXT PRIMARY KEY,
  title TEXT,
  year TEXT,
  genre TEXT,
  country TEXT
);

CREATE TABLE IF NOT EXISTS dw.users (
  user_id INT PRIMARY KEY,
  name TEXT,
  age INT,
  country TEXT
);

CREATE TABLE IF NOT EXISTS dw.ratings (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES dw.users(user_id),
  imdb_id TEXT REFERENCES dw.movies(imdb_id),
  rating INT,
  timestamp TIMESTAMP
);
SQL

# Determine paths inside host vs container
MOVIES_CSV="${DATA_DIR}/movies.csv"
USERS_CSV="${DATA_DIR}/users.csv"
RATINGS_CSV="${DATA_DIR}/ratings.csv"

if [ -f "$MOVIES_CSV" ]; then
  echo "Importando movies.csv"
  psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\COPY dw.movies(imdb_id,title,year,genre,country) FROM '$MOVIES_CSV' CSV HEADER;"
else
  echo "Aviso: $MOVIES_CSV não encontrado, pulando import movies"
fi

if [ -f "$USERS_CSV" ]; then
  echo "Importando users.csv"
  psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\COPY dw.users(user_id,name,age,country) FROM '$USERS_CSV' CSV HEADER;"
else
  echo "Aviso: $USERS_CSV não encontrado, pulando import users"
fi

if [ -f "$RATINGS_CSV" ]; then
  echo "Importando ratings.csv"
  psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\COPY dw.ratings(user_id,imdb_id,rating,timestamp) FROM '$RATINGS_CSV' CSV HEADER;"
else
  echo "Aviso: $RATINGS_CSV não encontrado, pulando import ratings"
fi

echo "Import concluído."
