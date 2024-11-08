FROM bitnami/mariadb:11.5.2-debian-12-r5@sha256:9d16317d77fa765af11bc0c95a17fd69e637f15fa4544294253c2791c692a7ea

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
