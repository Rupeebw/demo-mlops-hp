# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an end-to-end MLOps project for house price prediction. The pipeline includes data processing, feature engineering, model training with MLflow tracking, and deployment via FastAPI and Streamlit interfaces.

## Development Environment Setup

**Python Version**: 3.11

**Environment Setup**:

```bash
# Create virtual environment using UV
uv venv --python python3.11
source .venv/bin/activate

# Install dependencies
uv pip install -r requirements.txt
```

**MLflow Setup**:

```bash
# Start MLflow tracking server (accessible at http://localhost:5555)
cd deployment/mlflow
docker compose -f mlflow-docker-compose.yml up -d
docker compose ps

# Alternative for Podman users
podman compose -f mlflow-docker-compose.yml up -d
```

**JupyterLab** (optional):

```bash
python -m jupyterlab
```

## ML Pipeline Commands

### Complete Pipeline Execution (in order):

1. **Data Processing**:

```bash
python src/data/run_processing.py \
  --input data/raw/house_data.csv \
  --output data/processed/cleaned_house_data.csv
```

2. **Feature Engineering**:

```bash
python src/features/engineer.py \
  --input data/processed/cleaned_house_data.csv \
  --output data/processed/featured_house_data.csv \
  --preprocessor models/trained/preprocessor.pkl
```

3. **Model Training**:

```bash
python src/models/train_model.py \
  --config configs/model_config.yaml \
  --data data/processed/featured_house_data.csv \
  --models-dir models \
  --mlflow-tracking-uri http://localhost:5555
```

## Testing Commands

```bash
# Run all tests
pytest

# Run specific test file
pytest tests/test_file.py

# Run with verbose output
pytest -v
```

## Application Deployment

### FastAPI Serving

The FastAPI application serves predictions via REST API.

**Expected Structure**:

- `Dockerfile` in root directory
- FastAPI source in `src/api/`
- Model paths: `models/trained/house_price_model.pkl` and `models/trained/preprocessor.pkl`

**Test Prediction**:

```bash
curl -X POST "http://localhost:8000/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "sqft": 1500,
    "bedrooms": 3,
    "bathrooms": 2,
    "location": "suburban",
    "year_built": 2000,
    "condition": "fair"
  }'
```

### Streamlit UI

The Streamlit app provides a web interface for predictions.

**Expected Structure**:

- `streamlit_app/Dockerfile` for containerization
- Environment variable: `API_URL=http://fastapi:8000` (when using docker-compose)

### Docker Compose Deployment

**Expected Structure**:

- `docker-compose.yaml` in root directory
- Should launch both FastAPI and Streamlit services
- Streamlit requires `API_URL` environment variable pointing to FastAPI service

## Architecture and Data Flow

### Pipeline Architecture

The project follows a three-stage ML pipeline:

1. **Data Processing** (`src/data/run_processing.py`):

   - Loads raw CSV data
   - Handles missing values (median for numeric, mode for categorical)
   - Removes outliers using IQR method on price column
   - Outputs cleaned CSV
2. **Feature Engineering** (`src/features/engineer.py`):

   - Creates derived features:
     - `house_age`: current_year - year_built
     - `price_per_sqft`: price / sqft
     - `bed_bath_ratio`: bedrooms / bathrooms
   - Creates and fits preprocessing pipeline using sklearn ColumnTransformer
   - Numerical features: ['sqft', 'bedrooms', 'bathrooms', 'house_age', 'price_per_sqft', 'bed_bath_ratio']
   - Categorical features: ['location', 'condition'] (one-hot encoded)
   - Saves fitted preprocessor as pickle file
   - Outputs transformed features CSV
3. **Model Training** (`src/models/train_model.py`):

   - Loads model configuration from YAML (configs/model_config.yaml)
   - Supports: LinearRegression, RandomForest, GradientBoosting, XGBoost
   - Logs to MLflow: parameters, metrics (MAE, R²), model artifacts
   - Registers model in MLflow Model Registry
   - Transitions model to "Staging" stage
   - Saves trained model locally as pickle
   - Tags registered model with metadata (algorithm, hyperparameters, dependencies)

### Inference Architecture

**FastAPI Service** (`src/api/`):

- `main.py`: FastAPI application with endpoints
  - `/health`: Health check
  - `/predict`: Single prediction
  - `/batch-predict`: Batch predictions
- `inference.py`: Loads model and preprocessor, performs inference
  - Recreates engineered features at inference time (house_age, bed_bath_ratio, price_per_sqft)
  - Applies preprocessor transformation
  - Returns prediction with confidence interval
- `schemas.py`: Pydantic models for request/response validation
- Expects models at: `models/trained/house_price_model.pkl` and `models/trained/preprocessor.pkl`

**Streamlit App** (`streamlit_app/app.py`):

- Web UI for predictions
- Connects to FastAPI via `API_URL` environment variable (default: "http://model:8000")
- Displays prediction results with confidence intervals
- Falls back to mock data if API unavailable

### Key Dependencies

The preprocessor must be created during feature engineering and reused during:

- Model training (to transform training data)
- Inference (to transform incoming requests)

The same feature engineering logic from `engineer.py` is replicated in `inference.py` for consistency.

## Important Notes

### Model Configuration

Model training expects a YAML config file at `configs/model_config.yaml` with structure:

```yaml
model:
  name: "house_price_model"
  best_model: "XGBoost"  # or LinearRegression, RandomForest, GradientBoosting
  target_variable: "price"
  parameters:
    # model-specific hyperparameters
```

### File Paths and Artifacts

- Raw data: `data/raw/house_data.csv`
- Processed data: `data/processed/cleaned_house_data.csv`
- Featured data: `data/processed/featured_house_data.csv`
- Preprocessor: `models/trained/preprocessor.pkl`
- Trained model: `models/trained/house_price_model.pkl` (or name from config)
- MLflow artifacts: Tracked in MLflow server

### Feature Engineering Consistency

When modifying feature engineering logic:

1. Update `src/features/engineer.py` (training pipeline)
2. Update `src/api/inference.py` (inference pipeline)
3. Ensure preprocessor captures all transformations
4. Retrain both preprocessor and model

### MLflow Integration

- Tracking URI: http://localhost:5555 (default)
- Models are registered in MLflow Model Registry
- Model transitions: None → Staging → Production (manual promotion recommended)
- Experiment name matches model name from config
