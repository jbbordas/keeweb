#
# Petit docker afin d'avoir un keeweb simple en HTTP non root
# Ce container doit etre mis deriere un proxy pour sécuriser la connexion (TRAEFIK,NGINX,...)
#

# On par de 'image officiel de NGINX
FROM nginx:1.17.6
LABEL maintainer="BBO <admin@whita.net>" 
#argument
ENV PUID=1000
ENV PGID=1000

#installation des packages necessaires
RUN apt-get -y update && apt-get -y install wget unzip && rm -rf /var/lib/apt/lists/*

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

#change l'utilisateur non-root nginx UID and GID
RUN usermod -u ${PUID} nginx
RUN groupmod -g ${PGID} nginx

#bascule dans le répertoir de travail d'nginx
WORKDIR /app

#récupération des packages pour keeweb
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
RUN apt-get -y remove wget unzip

#création des chemin et fichier necessaire au cas ou
RUN mkdir -p /var/log/nginx && \
    touch /var/log/nginx/error.log && \
    touch /var/log/nginx/access.log && \
    mkdir /data
        

# Ajout des permissions pour l'utilisateur nginx
RUN chown -R nginx:nginx /app && \
        chmod -R 755 /app && \
        chown -R nginx:nginx /var/cache/nginx && \
        chown -R nginx:nginx /var/log/nginx && \
        chown -R nginx:nginx /etc/nginx/conf.d 
RUN touch /data/nginx.pid && \
        chown -R nginx:nginx /data && \
        chown -R nginx:nginx /data/nginx.pid

#On passe a l'utilisateur nginx
USER nginx

EXPOSE 8888

## on demarre le serveur
CMD ["nginx", "-g", "daemon off;"]

