
FROM python:3.8-alpine3.12

RUN python3 -m pip install chalice
RUN python3 -m pip install httpie
RUN python3 -m pip install pytest

WORKDIR /app
COPY . .
EXPOSE 8000
CMD ["/usr/local/bin/chalice", "local"]

