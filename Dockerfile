FROM bitnami/mariadb:11.6.2-debian-12-r0@sha256:1903a4cec8cdb3eb157e05c6cb65ef761445468da6c01bb54be4e16561b2a7c6

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
