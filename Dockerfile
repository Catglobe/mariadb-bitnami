FROM bitnami/mariadb:11.5.2-debian-12-r0@sha256:56cb1f8f2976b4600780791ff0ffc7c01f447200bbccea9c8c418aad399a2125

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
