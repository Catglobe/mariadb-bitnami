FROM bitnami/mariadb:11.5.2-debian-12-r2@sha256:f201dc3cda10b6c0c5c8fe21e2e8ce072aeb26edfae1ee3238e8e24ecdcca04b

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
