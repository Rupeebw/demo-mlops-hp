# Use Python 3.9 slim base image
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy all files from streamlit_app directory
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 8501
EXPOSE 8501

# Launch command
CMD ["streamlit", "run", "app.py", "--server.address=0.0.0.0"]
