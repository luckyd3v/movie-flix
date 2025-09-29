# MovieFlix Analytics

Plataforma fictícia de cadastro e avaliação de filmes + pipeline de dados.


## Funcionalidades

- App web (Node.js + Express) para cadastrar filmes e avaliações.
- Frontend simples (HTML + JS).
- Nginx como proxy reverso.
- Postgres como Data Warehouse.
- Data Lake: CSVs em ./data_lake.
- ETL simples: scripts/load_into_db.sh carrega CSVs para o Postgres.
- Data Mart: views em sql/02_create_datamart_views.sql.
- CI/CD: GitHub Actions em .github/workflows/ci.yml (build, teste, push para Docker Hub).

## Rodando localmente

1) Build + levantar serviços:
```bash
docker-compose up --build -d
