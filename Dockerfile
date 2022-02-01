FROM nginx:1.17.6
MAINTAINER BBO <admin@whita.net>
#argument
ENV PUID=1000
ENV PGID=1000

#installation des package necessaire
RUN apt-get -y update && apt-get -y install openssl curl wget unzip && rm -rf /var/lib/apt/lists/*

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

#change the non-root user called nginx UID and GID

RUN usermod -u ${PUID} nginx
RUN groupmod -g ${PGID} nginx

WORKDIR /app


#récupération des package pour keeweb
RUN wget https://github.com/keeweb/keeweb/archive/gh-pages.zip; \
    unzip gh-pages.zip; \
    rm gh-pages.zip; \
    mkdir /app/keeweb; \
    mv keeweb-gh-pages/* /app/keeweb; \
    rm -rf keeweb-gh-pages;

RUN wget https://github.com/keeweb/keeweb-plugins/archive/master.zip; \
    unzip master.zip; \
    rm master.zip; \
    mkdir /app/keeweb/plugins; \
    mv keeweb-plugins-master/docs /app/keeweb/plugins; \
    rm -rf keeweb-puglins-master

#supression des packages inutiles
RUN apt-get -y remove openssl curl wget unzip

RUN mkdir -p /var/log/nginx && \
    touch /var/log/nginx/error.log && \
    touch /var/log/nginx/access.log 
        

## add permissions for nginx user
RUN chown -R nginx:nginx /app && \
        chmod -R 755 /app && \
        chown -R nginx:nginx /var/cache/nginx && \
        chown -R nginx:nginx /var/log/nginx && \
        chown -R nginx:nginx /etc/nginx/conf.d 
RUN touch /var/run/nginx.pid && \
        chown -R nginx:nginx /var/run/nginx.pid


USER nginx

EXPOSE 8888

## run server
CMD ["nginx", "-g", "daemon off;"]

