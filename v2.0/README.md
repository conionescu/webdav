# WebDAV in Docker
## Run Container

docker run -it -p3443:443 -p 3080:80 -v /root/docker-compose/conionescu-webdav/v2.0/dav:/dav -e USERNAME=test -e PASSWORD=test -e SSL_CERT=selfsigned --rm aein/webdav

docker run -it -p3443:443 -p 3080:80 -v /docker-data/dav:/dav:z -e USERNAME=test -e PASSWORD=test -e SSL_CERT=selfsigned --rm -d aein/webdav bash


