FROM foogaro/rhel

MAINTAINER Foogaro <l.fugaro@gmail.com>

ADD software/jboss-dv-6.3.0-installer.jar /opt/rh/jboss-dv-6.3.0-installer.jar
ADD software/jboss-dv-6.3.0-teiid-jdbc.jar /opt/rh/jboss-dv-6.3.0-teiid-jdbc.jar
ADD software/jboss-dv-6.3.5-patch.jar /opt/rh/jboss-dv-6.3.5-patch.jar
ADD software/jboss-dv-psqlodbc-6.2.0-3.el7.x86_64.rpm /opt/rh/jboss-dv-psqlodbc-6.2.0-3.el7.x86_64.rpm
ADD software/installer.xml.variables /opt/rh/installer.xml.variables
ADD software/installer.xml /opt/rh/installer.xml

RUN java -jar /opt/rh/jboss-dv-6.3.0-installer.jar /opt/rh/installer.xml

RUN java -jar /opt/rh/jboss-dv-6.3.5-patch.jar --server /opt/rh/jdv --update jboss-dv

RUN rm -rf /opt/rh/jdv/standalone/configuration/standalone_xml_history/current

ADD software/mysql-connector-java-5.1.40-bin.jar /opt/rh/mysql-connector-java-5.1.40-bin.jar
ADD software/teiid-1.cli /opt/rh/teiid-1.cli
ADD software/teiid-2.cli /opt/rh/teiid-2.cli
ADD software/teiid-3.cli /opt/rh/teiid-3.cli
ADD software/mysql.cli /opt/rh/mysql.cli
ADD software/configure.sh /opt/rh/configure.sh
ADD software/standalone.conf /opt/rh/jdv/bin/standalone.conf
ADD software/logging.cli /opt/rh/logging.cli
ADD software/EMP.vdb /opt/rh/EMP.vdb

EXPOSE 8080 8009 9990 9999 9443 45700/udp 45688/udp 55200/udp 54200/udp 4447 31000 35432 23364/udp

ENTRYPOINT ["/opt/rh/jdv/bin/standalone.sh"]



