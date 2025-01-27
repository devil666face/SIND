FROM debian:12

ENV container docker
ENV CONTAINER_TIMEZONE Etc/UTC
ENV DEBIAN_FRONTEND noninteractive
ENV SYSTEMD_LOG_LEVEL debug

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && \
    echo $CONTAINER_TIMEZONE > /etc/timezone

ARG SYSTEMD_PKG="systemd systemd-sysv"

RUN apt-get update --quiet --quiet && \
    apt-get install --quiet --quiet --yes \
    ${SYSTEMD_PKG} \
    && \
    apt-get --quiet --quiet clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -rf /lib/systemd/system/multi-user.target.wants/* && \
    rm -rf /etc/systemd/system/*.wants/* && \
    rm -rf /lib/systemd/system/local-fs.target.wants/* && \
    rm -rf /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -rf /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -rf /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* && \
    rm -rf /lib/systemd/system/systemd-update-utmp*

VOLUME [ "/sys/fs/cgroup" ]

COPY entrypoint.service /etc/systemd/system/entrypoint.service
COPY entrypoint.sh .

RUN chmod +x /entrypoint.sh && \
    ln -sf /etc/systemd/system/entrypoint.service /etc/systemd/system/multi-user.target.wants/entrypoint.service

ENTRYPOINT ["/lib/systemd/systemd"]
CMD ["/lib/systemd/systemd"]
