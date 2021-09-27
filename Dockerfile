# docker run -d -p 8000:8000 alseambusher/crontab-ui
FROM alpine:3.13.5

RUN sed -i 's!https://dl-cdn.alpinelinux.org/!https://mirrors.ustc.edu.cn/!g' /etc/apk/repositories

ENV PYTHONUNBUFFERED=1


ENV   CRON_PATH /etc/crontabs

RUN   mkdir /crontab-ui; touch $CRON_PATH/root; chmod +x $CRON_PATH/root

WORKDIR /crontab-ui


LABEL maintainer "@alseambusher"
LABEL description "Crontab-UI docker"

RUN   apk --no-cache add \
      wget \
      curl \
      nodejs \
      make \
      cmake \
      g++ \
      gfortran \
      npm \
      supervisor \
      vim \
      py-pip \ 
      python-dev \
      tzdata

COPY supervisord.conf /etc/supervisord.conf
COPY . /crontab-ui


RUN   npm install

ENV   HOST 0.0.0.0

ENV   PORT 8000

ENV   CRON_IN_DOCKER true

EXPOSE $PORT

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
