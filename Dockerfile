FROM python:3.11-slim

# 1. Environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
# Ensure the pip-installed binaries are in the PATH
ENV PATH="/home/appuser/.local/bin:${PATH}"

WORKDIR /app

# 2. Setup user early
RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup

# 3. Install dependencies as the user to avoid permission/path mismatches
COPY requirements.txt .
USER appuser
RUN pip install --no-cache-dir --user -r requirements.txt

# 4. Copy code and fix ownership (switch to root briefly to chown if needed)
USER root
COPY . .
RUN chown -R appuser:appgroup /app

# 5. Final Switch to non-root
USER appuser

EXPOSE 5000

# 6. Use the full path to gunicorn to be safe
CMD ["/home/appuser/.local/bin/gunicorn", "-w", "2", "-b", "0.0.0.0:5000", "app:app"]