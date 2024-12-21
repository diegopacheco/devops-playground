from __future__ import annotations
import time
import random

import pendulum
from airflow.decorators import dag, task
from airflow.operators.empty import EmptyOperator
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.datasets import Dataset

SQL_1="INSERT INTO airflowsample (col1) VALUES ('row')"

SQL_2="DROP TABLE airflowsample"

@dag(
    schedule=[Dataset("sample_pg_table")],
    start_date=pendulum.datetime(2021, 1, 1, tz="UTC"),
    catchup=False,
    tags=["example"],
    dag_display_name="Flaky DAG - 2",
)

def example_insert_brkn():

    sample_task_1 = EmptyOperator(
        task_id="sample_insert_task_1",
        task_display_name="Sample Task 1",
    )

    sample_task_2 = SQLExecuteQueryOperator(
        task_id="sample_insert_task_2",
        sql=SQL_1,
        conn_id="AIRFLOW__CELERY__RESULT_BACKEND",
    )

    sample_task_3 = SQLExecuteQueryOperator(
        task_id="sample_insert_task_3",
        sql=SQL_2,
        conn_id="AIRFLOW__CELERY__RESULT_BACKEND",
    )

    sample_task_1 >> sample_task_2 >> sample_task_3

example_insert_brkn()