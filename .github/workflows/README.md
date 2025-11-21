# GitHub Actions ML Pipeline

This directory contains the GitHub Actions workflows for automating the ML pipeline from data processing to model training.

## 📋 Available Workflows

### 1. ML Pipeline (`ml-pipeline.yml`)

Complete end-to-end ML pipeline that runs:
1. **Data Processing** - Clean and prepare raw data
2. **Feature Engineering** - Create features and preprocessor
3. **Model Training** - Train and save the ML model

#### Triggers

The pipeline runs automatically on:
- **Push** to `main` or `develop` branches when changes are made to:
  - `src/**` (source code)
  - `data/raw/**` (raw data)
  - `configs/**` (configuration files)
  - `requirements.txt` (dependencies)
  - `.github/workflows/ml-pipeline.yml` (workflow file itself)

- **Pull Requests** to `main` or `develop` branches

- **Manual Trigger** via GitHub Actions UI with optional parameters:
  - `run_training`: Enable/disable model training step (default: true)

#### Jobs Overview

```
┌─────────────────────┐
│  Data Processing    │  ← Cleans raw data
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Feature Engineering │  ← Creates features & preprocessor
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  Model Training     │  ← Trains ML model
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Pipeline Summary    │  ← Reports overall status
└─────────────────────┘
```

#### Artifacts Generated

Each job produces artifacts that are passed to subsequent jobs:

| Job | Artifact | Retention | Description |
|-----|----------|-----------|-------------|
| Data Processing | `processed-data` | 7 days | Cleaned CSV data |
| Feature Engineering | `featured-data` | 7 days | Data with engineered features |
| Feature Engineering | `preprocessor` | 7 days | Fitted scikit-learn preprocessor |
| Model Training | `trained-model` | 30 days | Trained model (pickle file) |
| Model Training | `mlflow-artifacts` | 30 days | MLflow experiment tracking data |

## 🚀 Manual Workflow Execution

### Via GitHub UI

1. Go to the **Actions** tab in your repository
2. Select **ML Pipeline - Data Processing to Model Training**
3. Click **Run workflow**
4. Choose the branch
5. (Optional) Uncheck "Run model training" to skip training step
6. Click **Run workflow**

### Via GitHub CLI

```bash
# Run the complete pipeline
gh workflow run ml-pipeline.yml

# Run without model training
gh workflow run ml-pipeline.yml -f run_training=false

# Run on a specific branch
gh workflow run ml-pipeline.yml --ref develop
```

## 📊 Monitoring Pipeline Execution

### View Workflow Runs

```bash
# List recent workflow runs
gh run list --workflow=ml-pipeline.yml

# View details of a specific run
gh run view <run-id>

# Watch a running workflow
gh run watch <run-id>
```

### Download Artifacts

```bash
# List artifacts from a run
gh run view <run-id> --log

# Download all artifacts
gh run download <run-id>

# Download specific artifact
gh run download <run-id> -n trained-model
```

## 🔧 Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PYTHON_VERSION` | `3.11` | Python version for all jobs |
| `UV_VERSION` | `0.1.0` | UV package manager version |

### Required Files

The pipeline expects the following files to exist:

```
.
├── configs/
│   └── model_config.yaml          # Model configuration
├── data/
│   └── raw/
│       └── house_data.csv         # Raw input data
├── src/
│   ├── data/
│   │   └── run_processing.py      # Data processing script
│   ├── features/
│   │   └── engineer.py            # Feature engineering script
│   └── models/
│       └── train_model.py         # Model training script
└── requirements.txt               # Python dependencies
```

## ✅ Success Criteria

The pipeline is considered successful when:

- ✅ All data rows are processed without errors
- ✅ Preprocessor is created and saved
- ✅ Model is trained with acceptable metrics (MAE, R²)
- ✅ All artifacts are uploaded successfully

## ❌ Failure Handling

If any job fails:

1. Check the **Actions** tab for error logs
2. Review the specific job that failed
3. Common issues:
   - Missing raw data file
   - Dependency installation failures
   - Script argument mismatches
   - Insufficient memory (for large datasets)

## 🔒 Security Considerations

- **No Secrets Required**: This pipeline doesn't use external APIs or cloud services
- **Artifact Access**: Artifacts are stored in GitHub and accessible to repository collaborators
- **Data Privacy**: Ensure raw data doesn't contain sensitive information before committing

## 📝 Customization

### Adding New Steps

To add a new job to the pipeline:

1. Create a new job section in `ml-pipeline.yml`
2. Use `needs:` to define dependencies
3. Add artifact upload/download as needed
4. Update the `pipeline-summary` job to include the new step

### Modifying Retention Periods

Edit the `retention-days` parameter in artifact uploads:

```yaml
- name: Upload trained model
  uses: actions/upload-artifact@v4
  with:
    name: trained-model
    path: models/trained/house_price_model.pkl
    retention-days: 30  # Change this value
```

### Adding Notifications

Add notification steps at the end of jobs:

```yaml
- name: Notify on failure
  if: failure()
  run: |
    echo "Pipeline failed! Check logs for details."
    # Add Slack/Email notification here
```

## 🧪 Testing the Pipeline Locally

Before pushing changes, test the pipeline steps locally:

```bash
# 1. Data Processing
python src/data/run_processing.py \
  --input data/raw/house_data.csv \
  --output data/processed/cleaned_house_data.csv

# 2. Feature Engineering
python src/features/engineer.py \
  --input data/processed/cleaned_house_data.csv \
  --output data/processed/featured_house_data.csv \
  --preprocessor models/trained/preprocessor.pkl

# 3. Model Training
python src/models/train_model.py \
  --config configs/model_config.yaml \
  --data data/processed/featured_house_data.csv \
  --models-dir models
```

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Workflow Syntax Reference](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Artifact Upload/Download](https://github.com/actions/upload-artifact)
- [GitHub CLI](https://cli.github.com/)

## 🤝 Contributing

When modifying the pipeline:

1. Test changes on a feature branch first
2. Use `workflow_dispatch` trigger for testing
3. Document any new environment variables or configurations
4. Update this README with changes
