#!/usr/bin/env bash

sed -i -e 's/DOCKER_MYSQL_IP/'$DOCKER_MYSQL_IP'/g' /opt/rh/mysql.cli
sed -i -e 's/DOCKER_MYSQL_PORT/'$DOCKER_MYSQL_PORT'/g' /opt/rh/mysql.cli
sed -i -e 's/DOCKER_MYSQL_DBNAME/'$DOCKER_MYSQL_DBNAME'/g' /opt/rh/mysql.cli

MYIP=`ifconfig eth0 | grep "inet " | awk  '{ print $2 }'`

/opt/rh/jdv/bin/jboss-cli.sh --connect --controller=$MYIP:9999 --file=/opt/rh/logging.cli

/opt/rh/jdv/bin/jboss-cli.sh --connect --controller=$MYIP:9999 --file=/opt/rh/mysql.cli

sleep 30

/opt/rh/jdv/bin/jboss-cli.sh --connect --controller=$MYIP:9999 --file=/opt/rh/teiid-1.cli

sleep 30

/opt/rh/jdv/bin/jboss-cli.sh --connect --controller=$MYIP:9999 --file=/opt/rh/teiid-2.cli

sleep 30

/opt/rh/jdv/bin/jboss-cli.sh --connect --controller=$MYIP:9999 --file=/opt/rh/teiid-3.cli

sleep 30

/opt/rh/jdv/bin/jboss-cli.sh --connect --controller=$MYIP:9999 --command="deploy /opt/rh/EMP.vdb"


