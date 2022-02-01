## Supported tags

* [`v1`, `latest`](https://github.com/jbbordas/keeweb)

## Quick reference

This image runs an easily keeweb app with nginx.

every think is http. you must put this behide a proxy to have https.

* **Code repository:**
https://github.com/jbbordas/keeweb
* **Where to file issues:**
https://github.com/jbbordas/keeweb/issues
* **Maintained by:**
  [diablo887]


## Usage

### Basic keeweb server

This example starts a keeweb page on port 8888. no authentication or https is provided

no file will be save. use only distance base with webdav for exemple


```
docker run --restart always \
    -e PUID=1000 -e PGID=1000 \
    --publish 8888:8888 -d diablo887/keeweb

```

#### Via Docker Compose:

```
version: '3'
services:
  keeweb:
    image: diablo887/keeweb
    restart: always
    ports:
      - "8888:8888"
    environment:
      PUID: 1000 
      PGID: 1000 

```

### Environment variables

All environment variables are optional. You probably want to at least specify `USERNAME` and `PASSWORD` (or bind mount your own authentication file to `/user.passwd`) otherwise nobody will be able to access your WebDAV server!

* **`PUID`**:  UID of the user who run nginx in the docker. default is 1000
* **`PGID`**: GID of the user who run nginx in the docker. default is 1000
* **`TZ`**: the time zone use by nginx


