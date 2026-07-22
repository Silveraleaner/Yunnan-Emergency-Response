FROM postgis/postgis:15-3.4

RUN apt-get update && \
    apt-get install -y postgresql-15-pgvector && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ls -la /usr/share/postgresql/15/extension/vector.control

EXPOSE 5432