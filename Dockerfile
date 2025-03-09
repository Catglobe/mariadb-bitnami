FROM bitnami/mariadb:11.7.2-debian-12-r0@sha256:16a7dae804fbc527af719daea760744071b07c96d6c0523861d9f3d57150f331

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
