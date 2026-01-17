import gradio as gr
import requests

def trigger_pipeline():
    r = requests.post("http://localhost:8000/run-ingestion")
    return r.json()["status"]

ui = gr.Interface(
    fn=trigger_pipeline,
    inputs=None,
    outputs="text",
    title="Dagster Pipeline Trigger"
)

ui.launch()