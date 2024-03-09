# Base Image
FROM python:3.9-alpine3.13

# Label => label the application 
LABEL maintainer="drcheydev.com"

# Tell Docker not to buffer the output which may cause delays 
ENV PYTHONUNBUFFERED 1

# Copy
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

WORKDIR /app

EXPOSE 8000

ARG DEV=false
#1 . Create a virtual enviroment
#2. install pip 
#3. install requirements
#4. add user -> django-user
#5. disable password, doesnt create home  
RUN python -m venv /py && \ 
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser \
    --disabled-password \
    --no-create-home \
    django-user

# Update the enviroment to run from our venv 
ENV PATH="/py/bin:$PATH"

USER django-user
