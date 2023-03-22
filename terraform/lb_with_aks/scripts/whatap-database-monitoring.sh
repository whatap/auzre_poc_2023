#!/usr/bin/env bash

apt install -y openjdk-11-jdk-headless unzip

mkdir /data -p
cd /data 
wget -O whatap.agent.database.tar.gz https://service.whatap.io/download/agent/whata.agent.database.tar.gz

tar -xvf whatap.agent.database.tar.gz
cd whatap

wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.22.zip
unzip mysql-connector-java-8.0.22.zip 

cp mysql-connector-java-8.0.22/mysql-connector-java-8.0.22.jar jdbc

MYSQL_ENDPOINT=petclinic-mysqlfs-vxggqael.mysql.database.azure.com
DB_USER=mysqladminun
DB_PASSWD='H@Sh1CoR3!'

cat <<EOF > whatap.conf
license=x2aggu6f4kv5r-z4df0igvcb3i9s-z6k73ibr32od3o
whatap.server.host=ec2-54-180-154-217.ap-northeast-2.compute.amazonaws.com

dbms=mysql
db_ip=$MYSQL_ENDPOINT
db_port=3306

connect_option=?useSSL=true&verifyServerCertificate=false
EOF

./uid.sh $DB_USER $DB_PASSWD

./startd.sh
