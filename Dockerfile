FROM bitnami/mariadb:11.8.3-debian-12-r0@sha256:ada2a782b0bdd7885bda684af7fb1fdaa57929c35e639f7cbbf3f724a1735a31

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
