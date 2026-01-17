from fastapi import FastAPI
import subprocess

app = FastAPI()

@app.post("/run-ingestion")
def run_ingestion():
    cmd = [
        "dagster", "job", "execute",
        "-f", "src/dagster_pipeline.py",
        "-j", "static_ingestion_job"
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    return {
        "status": "triggered",
        "stdout": result.stdout,
        "stderr": result.stderr
    }
