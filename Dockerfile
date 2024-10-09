FROM bitnami/mariadb:11.4.3-debian-12-r1

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
