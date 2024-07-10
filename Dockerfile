FROM bitnami/mariadb:11.3.2-debian-12-r9@sha256:320c70dfd914311039128ce656b6dd89a563c81852881e7942feed4f7edc3df6

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
