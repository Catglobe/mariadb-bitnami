FROM bitnami/mariadb:11.4.2-debian-12-r0@sha256:4905dcf51a47ae67b599c6096adf41a6125c74a7193f498dcf0725b0888c187d

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
