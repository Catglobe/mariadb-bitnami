FROM bitnami/mariadb:11.4.3-debian-12-r0@sha256:8b3778160e34094c0aa82a626a612a382bb6536b37c750ed6729c0bffb4e86b6

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
