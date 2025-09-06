FROM bitnami/mariadb:12.0.2-debian-12-r0@sha256:888cdaae3cb996c4d28f7916106511de553545929957dd1d35221112df631e19

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
