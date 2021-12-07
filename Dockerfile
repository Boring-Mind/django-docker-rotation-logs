FROM python:3.10-slim as compile_step

# Don't forget to use Docker BuildKit technology
# https://docs.docker.com/develop/develop-images/build_enhancements/
#RUN apt-get update && apt-get install -y gcc g++

# Make a folder where our built packages would be
RUN mkdir -p /build/wheels

# Convert our dependencies from poetry to pip format
COPY pyproject.toml ./poetry.lock* /
RUN pip3 install -U pip wheel poetry
RUN poetry export -f requirements.txt --without-hashes -o /tmp/requirements.txt

# Compile all our dependencies into one wheel
RUN pip3 wheel --wheel-dir=/build/wheels -r /tmp/requirements.txt

FROM python:3.10-slim as run_step

# Import compiled python dependencies from previous step
COPY --from=compile_step /build/wheels /tmp/wheels

# Install python dependencies
RUN pip3 install -U pip wheel
RUN pip3 install --no-cache-dir /tmp/wheels/* && rm -rf /tmp/wheels

EXPOSE 8000

WORKDIR /app

COPY ./logs_app /app

CMD ["python3", "-m", "gunicorn", "logs_app.wsgi:application", "-c", "/app/gunicorn_conf.py"]
# "--error-logfile", "/app/django.log", "--capture-output"]