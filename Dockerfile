FROM bitnami/mariadb:11.4.3-debian-12-r3@sha256:42235ecbfd9808d038320c05a2635742caf9fad3f568b35e11d3dde60dbc27c2

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
