ARG TAG=latest

FROM docker.io/postgres:$TAG

COPY install-packages.sh install-packages.sh
RUN chmod +x ./install-packages.sh
RUN ./install-packages.sh
RUN rm ./install-packages.sh

COPY backup-to-dropbox.sh backup-to-dropbox.sh
RUN chmod +x backup-to-dropbox.sh

ENV APP ""
ENV DROPBOX_BEARER_TOKEN ""

ENTRYPOINT ["sh", "backup-to-dropbox.sh"]
