FROM python:3.12-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements /tmp/requirements
RUN python3 -m pip install --no-cache-dir -r /tmp/requirements/main.txt \
    && rm -rf /tmp/requirements

# Add non-root user
ARG GROUP_ID=1000
ENV GROUP_ID=${GROUP_ID}
RUN addgroup --system --gid ${GROUP_ID} user
ARG USER_ID=1000
ENV USER_ID=${USER_ID}
RUN adduser --disabled-password --gecos ''  --uid ${USER_ID} --gid ${GROUP_ID} user && \
    mkdir -p /app && chown -R user:user /app

# Copy application code
COPY --chown=user:user eva /app/eva

USER user

# Create necessary directories
RUN mkdir -p /app/documents /app/chroma_db /app/logs

# Expose port
EXPOSE 8000
ENV PORT=8000
# Run the application
CMD ["python", "-m", "eva.main"]