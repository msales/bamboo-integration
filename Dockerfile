FROM alpine

MAINTAINER Bartek R "bojleros@gmail.com"

ARG GITHUB_USER
ARG GITHUB_TOKEN

RUN apk add --no-cache py3-flask

ENV APP_DIR /app

RUN mkdir /app

COPY main.py /app

WORKDIR /app

RUN test -n "${GITHUB_TOKEN}" && \
  echo -ne "machine github.com\n\tlogin ${GITHUB_USER}\n\tpassword ${GITHUB_TOKEN}\n" > .netrc || \
  true

ENTRYPOINT ["python3"]
CMD ["-u", "main.py"]

