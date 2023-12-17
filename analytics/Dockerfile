FROM python:3.11.5-bookworm

WORKDIR /app
COPY . /app

# Install all python dependence to run app
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Expose port 80 for backend
EXPOSE 80

# Set environment variable for application
ENV NAME UdacityProject3

# Finally run python backend application
CMD ["python", "app.py"]
