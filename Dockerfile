# Specify the base image which we are using
FROM python:3.9-alpine3.13

# Maintainer, name or domain
LABEL maintaner="Chandan Gowda"

# Python output should not be buffered before showing the output
ENV PYTHONUNBUFFERED 1

# Copy the required files to the container
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app

# Expose the port which we will use to connect to the container
EXPOSE 8000

# Run commands to create a virtual environment, install requirements and the add a new user
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Updating the path in env to make sure we run commands inside the virtual env we have created
ENV PATH="/py/bin:$PATH"

# Switch to the user we have created
USER django-user
