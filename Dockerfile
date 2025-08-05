FROM bitnami/mariadb:11.8.2-debian-12-r4@sha256:bbd4e17f1ef8e035c74381c29c64627eaca2ca8612118f3caa5686c3ed8c7bbf

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
