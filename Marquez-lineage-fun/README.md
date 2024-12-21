### Install Marquez

```bash
git clone https://github.com/MarquezProject/marquez && cd marquez
```

optionaly can add as sub-module:
```bash
git submodule add https://github.com/MarquezProject/marquez marquez
```

### Run Marquez

```bash
./docker/up.sh --seed
```

### Open Marquez

http://localhost:3000

<img src="Marquez-ui.png" width="800" height="400">

### Install Airflow, send data to Marquez

1. Run Marquez

```bash
git clone https://github.com/MarquezProject/marquez && cd marquez
 ./docker/up.sh --db-port 2345
```

2. Configure Airflow

```bash
export AIRFLOW__OPENLINEAGE__TRANSPORT='{"type": "http", "url": "http://localhost:5000", "endpoint": "api/v1/lineage"}'

export AIRFLOW__OPENLINEAGE__NAMESPACE='my-team-airflow-instance'
```

3. Install OpenLineage

```bash
pip install apache-airflow-providers-openlineage 
pip install apache-airflow-providers-postgres
```

4. Run Airflow

```bash
mkdir airflow/ && cd airflow/
curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.10.4/docker-compose.yaml'
mkdir -p ./dags ./logs ./plugins ./config
echo -e "AIRFLOW_UID=$(id -u)" > .env
cp dag1.py dag2.py ./airflow/dags/
docker compose up airflow-init
docker compose up
curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.10.4/airflow.sh'
chmod +x airflow.sh
./airflow.sh info
./airflow.sh python
```

goto: http://localhost:8080/home
user: airflow pass: airflow

5. Run Postgres

```bash
docker run --name postgres -e POSTGRES_PASSWORD=yourpassword postgres
```

6. Add dags to Airflow

7. Look at Marquez UI