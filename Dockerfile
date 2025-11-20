# Use Python 3.11 slim base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements file
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy API source files
COPY src/api/main.py .
COPY src/api/schemas.py .
COPY src/api/inference.py .

# Copy trained models
COPY models/trained/house_price_model.pkl models/trained/
COPY models/trained/preprocessor.pkl models/trained/

# Expose port 8000
EXPOSE 8000

# Launch command
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
