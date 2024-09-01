FROM bitnami/mariadb:11.5.2-debian-12-r1@sha256:96101f23eeef4c951aaaf1b3fb60a664567bca27d14e5644758be7a4004eea21

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
