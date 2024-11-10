FROM bitnami/mariadb:11.5.2-debian-12-r6@sha256:1e1fd20b91fa36c93423a861b7d644175f925203594dcce1de4888b73704e8ff

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
