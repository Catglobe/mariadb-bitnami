FROM bitnami/mariadb:11.2.4-debian-12-r4@sha256:1d94be67a5ea69b97e70b3cf3de6823a60ce23841c195a9c76dd860e6997f028

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
