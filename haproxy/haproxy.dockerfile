FROM foogaro/rhel

MAINTAINER Foogaro <l.fugaro@gmail.com>

RUN yum install -y haproxy
RUN yum install -y which


ADD software/haproxyd.sh /etc/haproxy/haproxyd.sh
ADD software/haproxy.cfg /etc/haproxy/haproxy.cfg

EXPOSE 80 31000 35432

ENTRYPOINT ["/etc/haproxy/haproxyd.sh"]

CMD ["haproxy", "-f", "/etc/haproxy/haproxy.cfg"]
