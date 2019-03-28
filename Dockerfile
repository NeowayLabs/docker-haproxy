FROM haproxy:1.9.5
LABEL maintainer="blackops@neoway.com.br"

# Set envs
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN ln -sf /dev/stdout /var/log/haproxy.log \
 && apt-get -qqy update \
 && apt-get -qqy dist-upgrade \
 && apt-get -qqy install ca-certificates \
 && apt-get -qqy install rsyslog \
 && apt-get -qqy autoremove \
 && apt-get -qqy clean \
 && rm -rf /var/lib/apt/*

# Include rsyslog configuration
ADD ./rsyslog.conf /etc/rsyslog.conf

# Include ustom entrypoint that will the the job of lifting
# rsyslog alongside haproxy.
ADD ./entrypoint /entrypoint

# Set custom entrypoint as the image's default entrypoint
ENTRYPOINT [ "./entrypoint" ]

# Make haproxy use the default configuration file
CMD ["-f", "/etc/haproxy.cfg"]
