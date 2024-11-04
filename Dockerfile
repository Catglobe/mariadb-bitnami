FROM bitnami/mariadb:11.4.3-debian-12-r3@sha256:bfcf892fda619f5cad08b7f901f22862f2bb376e87fb204f312964d2c4ebc501

USER 0
RUN install_packages zstd awscli
COPY --chown=0:0 --chmod=555 ./backup.sh /usr/local/bin
USER 1001
