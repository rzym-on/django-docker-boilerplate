FROM python:3.7
ENV PYTHONUNBUFFERED 1

# Install requirements only if change was made -> https://stackoverflow.com/a/34399661/10451282
WORKDIR /app
COPY ./tools/requirements.txt /app
RUN pip install -r requirements.txt

COPY ./djangoplateapp/ /app/

ENTRYPOINT /app/docker-entrypoint.sh
