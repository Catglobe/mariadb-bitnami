FROM bitnami/mariadb:11.2.4-debian-12-r4

USER 0
COPY --chown=root:root --chmod=555 ./backup.sh /usr/local/bin
RUN install_packages zstd awscli
USER 1001
