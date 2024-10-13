FROM bitnami/mariadb:11.5.2-debian-12-r3@sha256:0b22e57cbb55e002eda38cb781331aee7bfe91931c6c62eec37c970019feb55d

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
