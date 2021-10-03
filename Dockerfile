FROM python:3.7-alpine 
#  The first line is the image that you are going to inherit your docker file from (도커에서는 자신의 목적에 맞게 외부 이미지를 끌어와 조금 수정하여 사용할 수 있다.). 
# MAINTAINER London App Developer Ltd 
# optional/ It's useful to know who's maintaining the project >> deprecated

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache postgresql-client jpeg-dev
RUN apk add --update --no-cache --virtual .temp-build-deps \
      gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev
RUN pip install -r /requirements.txt
RUN apk del .temp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
RUN adduser -D user
RUN chown -R user:user /vol/
RUN chmod -R 755 /vol/web
USER user