# docker run -d -p 8000:8000 alseambusher/crontab-ui
FROM alpine:3.13.5

RUN sed -i 's!https://dl-cdn.alpinelinux.org/!https://mirrors.ustc.edu.cn/!g' /etc/apk/repositories

ENV PYTHONUNBUFFERED=1

RUN echo "**** install Python ****" && \
    apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

ENV   CRON_PATH /etc/crontabs

RUN   mkdir /crontab-ui; touch $CRON_PATH/root; chmod +x $CRON_PATH/root

WORKDIR /crontab-ui

RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --no-cache-dir -r /crontab-ui/requirements.txt    

LABEL maintainer "@alseambusher"
LABEL description "Crontab-UI docker"

RUN   apk --no-cache add \
      wget \
      curl \
      nodejs \
      npm \
      supervisor \
      tzdata

COPY supervisord.conf /etc/supervisord.conf
COPY . /crontab-ui

RUN   npm install

ENV   HOST 0.0.0.0

ENV   PORT 8000

ENV   CRON_IN_DOCKER true

EXPOSE $PORT

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
