cd /d E:\mlops_session1
set DAGSTER_HOME=E:\mlops_session1\dagster_home
conda run -n mlops python -m dagster_webserver -w workspace.yaml
Open:
http://localhost:3000

Keep this running.

3) Run job synced (Terminal 2)
bat
Copy code
cd /d E:\mlops_session1
set DAGSTER_HOME=E:\mlops_session1\dagster_home

set INJECT_BAD_ROW=false
conda run -n mlops python -m dagster job execute -f src/dagster_pipeline.py -j static_ingestion_job
Now refresh UI → Runs → you will see the run.

4) FAIL demo (Terminal 2)
bat
Copy code
set INJECT_BAD_ROW=true
conda run -n mlops python -m dagster job execute -f src/dagster_pipeline.py -j static_ingestion_job