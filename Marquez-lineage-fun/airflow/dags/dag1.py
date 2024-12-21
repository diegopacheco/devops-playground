from __future__ import annotations
import time
import random

import pendulum
from airflow.decorators import dag, task
from airflow.operators.empty import EmptyOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.datasets import Dataset

SQL="""CREATE TABLE IF NOT EXISTS airflowsample (
    col1 VARCHAR(255), 
    col2 VARCHAR(255)
)"""

@dag(
    schedule='@hourly',
    start_date=pendulum.datetime(2021, 1, 1, tz="UTC"),
    catchup=False,
    tags=["example"],
    dag_display_name="Flaky DAG",
)

def example_display_name_brkn():

    sample_task_1 = EmptyOperator(
        task_id="sample_task_1",
        task_display_name="Sample Task 1",
    )

    sample_task_2 = SQLExecuteQueryOperator(
        task_id="sample_task_3",
        sql=SQL,
        conn_id="AIRFLOW__CELERY__RESULT_BACKEND",
    )

    @task(
        task_display_name="Sample Task 3",
        outlets=[Dataset("sample_pg_table")]
    )
    def sample_task_3():
        pers = [0, 60, 120, 'fail']
        per = random.choice(pers)
        time.sleep(per)

    sample_task_1 >> sample_task_2 >> sample_task_3()

example_display_name_brkn()