FROM python:3.12-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements /tmp/requirements
RUN pip install --no-cache-dir -r /tmp/requirements/main.txt \
    && rm -rf /tmp/requirements

# Copy application code
COPY eve /app/eve

# Create necessary directories
RUN mkdir -p documents chroma_db logs

# Expose port
EXPOSE 8000

# Run the application
CMD ["uvicorn", "eve.main:app", "--host", "0.0.0.0", "--port", "8000"]
