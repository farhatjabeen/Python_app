# our base image
FROM python:3.8 as build

WORKDIR /app

# Copy only the requirements file to optimize caching
COPY requirements.txt .

# install Python modules needed by the Python app
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

# copy files required for the app to run
COPY . .

# Create a lightweight runtime image
FROM python:3.8-slim

# Set the working directory in the runtime stage
WORKDIR /app

# Copy the installed dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages

# Copy the application code from the builder stage
COPY --from=builder /app /app

# tell the port number the container should expose
EXPOSE 5000

# run the application
CMD ["python", "/usr/src/app/app.py"]
