#!/bin/bash
set -ex

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE cratespro;
    GRANT ALL PRIVILEGES ON DATABASE cratespro TO mega;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "cratespro" -f /sql/pg_cratespro_20240424__init.sql
