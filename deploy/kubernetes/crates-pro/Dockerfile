FROM postgres:16.4

RUN mkdir -p /sql

# Add the database initialization script to the container
# When the container starts, PostgreSQL will automatically execute all .sql files in the docker-entrypoint-initdb.d/ directory
COPY ./pg_cratespro_20240424__init.sql /sql/
COPY ./init-databases.sh /docker-entrypoint-initdb.d/
