# MetroFlex AI Agent - Production Dockerfile for Railway
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy requirements first (better caching)
COPY ./AI_Agent/requirements-production.txt .

# Install dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements-production.txt

# Copy application files from AI_Agent directory
COPY ./AI_Agent/ .

# Expose port (Railway will set PORT env var)
EXPOSE 8080

# Run gunicorn
CMD gunicorn app:app --bind 0.0.0.0:$PORT --workers 2 --timeout 120
