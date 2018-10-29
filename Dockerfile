FROM alpine
MAINTAINER Bartek R "bojleros@gmail.com"
RUN apk add --no-cache py3-flask
ENV APP_DIR /app
RUN mkdir /app
COPY main.py /app
WORKDIR /app
ENTRYPOINT ["python3"]
CMD ["-u", "main.py"]

