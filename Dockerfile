FROM bitnami/mariadb:11.4.3-debian-12-r1@sha256:7ed3968f20d214c3f56546fe7cd392bb8184965aebb89e35de70ff458e10133f

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
