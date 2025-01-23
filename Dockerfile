# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Copy dependencies file
COPY requirements.txt .

# Install dependencies
RUN pip install -r requirements.txt

# Copy project files
COPY app.py .

# To ensure it's not overwritten during the build
COPY log.txt . 

# Make port 5001 available to the world outside this container
EXPOSE 5001

# Run the web service on container startup
CMD ["python", "app.py"]
