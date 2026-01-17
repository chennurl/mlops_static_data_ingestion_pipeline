# MLOps Static Data Ingestion Pipeline

[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![Dagster](https://img.shields.io/badge/orchestration-Dagster-success.svg)](https://dagster.io/)

A production-ready MLOps data pipeline for ingesting, validating, and processing static data using **Dagster** orchestration and **Pandera** schema validation.

## 📋 Overview

This project demonstrates a complete data ingestion workflow that:
- **Ingests** data from remote sources (via public APIs or CSV files)
- **Transforms** data to align with ML pipeline schemas
- **Validates** data integrity using strict schema rules
- **Orchestrates** the entire process with Dagster
- **Logs** results and handles failures gracefully

### Key Features
✅ **Schema Validation** - Pandera-based data quality checks  
✅ **Dagster Orchestration** - Job scheduling and monitoring  
✅ **Error Handling** - Configurable data validation modes  
✅ **Data Lake Structure** - Raw and landing zones  
✅ **Flexible Configuration** - Environment-based settings  

## 🏗️ Project Structure

```
mlops_static_data_ingestion_pipeline/
├── src/
│   ├── dagster_pipeline.py      # Dagster job and operations
│   ├── ingest_static.py         # Data ingestion and transformation logic
│   └── schema.py                # Pandera schema definitions
├── data/
│   ├── landing/                 # Processed data output
│   └── raw/                     # Raw ingested data
├── dagster_home/                # Dagster execution logs and storage
├── workspace.yaml               # Dagster workspace configuration
├── command                      # CLI entry point
├── set                          # Setup/configuration script
├── requirements.txt             # Python dependencies
├── .gitignore                   # Git ignore rules
└── README.md                    # This file
```

## 🚀 Quick Start

### Prerequisites
- Python 3.8 or higher
- pip or conda for package management

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/scai-learning-hub/mlops_static_data_ingestion_pipeline.git
cd mlops_static_data_ingestion_pipeline
```

2. **Install dependencies**
```bash
pip install -r requirements.txt
```

3. **Verify installation**
```bash
dagster --version
python -c "import pandera; print('Pandera installed!')"
```

## 📊 Data Flow

```
┌─────────────────────┐
│  External Data      │
│  (Remote CSV/API)   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Ingest & Extract   │
│  (ingest_static_op) │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Transform & Map    │
│  to Schema          │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Validate Data      │
│  (Pandera Schema)   │
└──────────┬──────────┘
           │
           ├─── Valid ──────▶ Landing Zone (processed)
           │
           └─── Invalid ──▶ Raw Zone + Error Handling
```

## 🔍 Schema Definition

The pipeline validates data against a strict schema:

| Column | Type | Constraints | Purpose |
|--------|------|-------------|---------|
| `event_time` | string | ISO 8601 format | Timestamp |
| `user_id` | integer | ≥ 1 | User identifier |
| `feature_num` | float | 0-100 range | Numerical feature |
| `feature_cat` | string | {A, B, C} | Categorical feature |
| `label` | integer | {0, 1} | Binary label |

See [src/schema.py](src/schema.py) for implementation details.

## 🎯 Usage

### Run the Pipeline

```bash
# Execute the Dagster job
dagster job execute -f src/dagster_pipeline.py -j static_ingestion_job

# Or with Dagster UI
dagster dev
```

### With Data Validation Errors

```bash
# Inject bad data for testing error handling
$env:INJECT_BAD_ROW = "true"
python -c "from src.ingest_static import ingest_static_data; ingest_static_data()"

# Or on Unix/Linux:
# INJECT_BAD_ROW=true python -c "from src.ingest_static import ingest_static_data; ingest_static_data()"
```

### Access Dagster UI

```bash
dagster dev
# Open http://localhost:3000 in your browser
```

## 📝 Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `INJECT_BAD_ROW` | `false` | Enable/disable error scenario testing |
| `DAGSTER_HOME` | `./dagster_home` | Dagster storage directory |

### Workspace Configuration

Edit [workspace.yaml](workspace.yaml) to add additional data sources or jobs:

```yaml
load_from:
  - python_file:
      relative_path: src/dagster_pipeline.py
      working_directory: .
```

## 📦 Dependencies

- **dagster** - Data orchestration framework
- **pandas** - Data manipulation
- **pandera** - Schema validation
- **PyYAML** - Configuration management

For complete list, see [requirements.txt](requirements.txt).

## 🧪 Testing

### Manual Testing
```bash
# Test ingestion without validation
python -c "from src.ingest_static import ingest_static_data; ingest_static_data()"

# Check output files
ls -la data/raw/
ls -la data/landing/
```

### Data Quality Checks
```python
from src.schema import schema
import pandas as pd

df = pd.read_csv("data/landing/landing.csv")
schema.validate(df)  # Raises if invalid
```

## 📊 Output

After successful execution:

- **Raw Data**: `data/raw/raw.csv` - Unprocessed ingested data
- **Landing Data**: `data/landing/landing.csv` - Validated, transformed data
- **Logs**: `dagster_home/logs/` - Execution logs and metrics

## 🔧 Development

### Project Structure Details

- **`src/dagster_pipeline.py`** - Defines Dagster ops and jobs
- **`src/ingest_static.py`** - Core ingestion and transformation logic
- **`src/schema.py`** - Pandera schema definitions
- **`workspace.yaml`** - Dagster workspace configuration

### Adding New Operations

```python
from dagster import op, job

@op
def my_new_op():
    # Your logic here
    pass

@job
def my_new_job():
    my_new_op()
```

## 🚨 Error Handling

The pipeline includes built-in error handling:
- **Schema validation failures** - Caught and logged
- **Missing data directories** - Automatically created
- **Source data unavailable** - Exception handling with logging

## 📖 Documentation

- [Dagster Documentation](https://docs.dagster.io/)
- [Pandera Documentation](https://pandera.readthedocs.io/)
- [Pandas Documentation](https://pandas.pydata.org/docs/)

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**SCAI Learning Hub**

- GitHub: [@scai-learning-hub](https://github.com/scai-learning-hub)

## 🙏 Acknowledgments

- Dagster team for the orchestration framework
- Pandera team for schema validation
- Seaborn for example datasets

## 📮 Support

For issues, questions, or suggestions:
- [Open an Issue](https://github.com/scai-learning-hub/mlops_static_data_ingestion_pipeline/issues)
- [Start a Discussion](https://github.com/scai-learning-hub/mlops_static_data_ingestion_pipeline/discussions)

---

**Last Updated**: January 11, 2026
