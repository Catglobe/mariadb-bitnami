FROM bitnami/mariadb:11.4.2-debian-12-r2@sha256:a7c5a110f197097d4b05ae5df9f399bbb011ab07cc2451ae6c5e366c80f9ba65

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
