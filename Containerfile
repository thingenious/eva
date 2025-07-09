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

# Add non-root user
ARG GROUP_ID=1000
ENV GROUP_ID=${GROUP_ID}
RUN addgroup --system --gid ${GROUP_ID} eva
ARG USER_ID=1000
ENV USER_ID=${USER_ID}
RUN adduser --disabled-password --gecos ''  --uid ${USER_ID} --gid ${GROUP_ID} eva && \
    mkdir -p /app && chown -R eva:eva /app

# Copy application code
COPY --chown=eva:eva eva /app/eva

# Create necessary directories
RUN mkdir -p /app/documents /app/chroma_db /app/logs

# Expose port
EXPOSE 8000
ENV PORT=8000
# Run the application
CMD ["python", "-m", "eva.main"]
