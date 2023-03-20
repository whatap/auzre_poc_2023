#!/usr/bin/env bash

curl https://get.docker.com |sh -
service docker start

apt install mysql-client -y
mysql -h $MYSQL_ENDPOINT -u "$DB_USER" -p"$DB_PASSWD" -e "CREATE DATABASE IF NOT EXISTS petclinic DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci"
mysql -h $MYSQL_ENDPOINT -u "$DB_USER" -p"$DB_PASSWD" -D petclinic -e "CREATE USER IF NOT EXISTS  petclinic@'%' IDENTIFIED BY 'petclinic'"
mysql -h $MYSQL_ENDPOINT -u "$DB_USER" -p"$DB_PASSWD" -D petclinic -e "GRANT ALL PRIVILEGES ON petclinic.* to petclinic@'%'"

mysql_ip=`basename $(dig +short $MYSQL_ENDPOINT A | tr '\n' '/')`

docker run -d \
--name petclinic \
--add-host mysql.local:$mysql_ip \
-p 8080:8080 \
registry.whatap.io:5000/hsnam/petclinic:0316

wget https://repo.whatap.io/debian/release.gpg -O -| apt-key add -
wget https://repo.whatap.io/debian/whatap-repo_1.0_all.deb
dpkg -i whatap-repo_1.0_all.deb
apt-get update

apt-get install whatap-infra

echo "license=x208gd4ir3din-z2fktjlbq6jn2o-z73juacinupans" |tee /usr/whatap/infra/conf/whatap.conf
echo "whatap.server.host=54.180.154.217" |tee -a /usr/whatap/infra/conf/whatap.conf
echo "createdtime=`date +%s%N`" |tee -a /usr/whatap/infra/conf/whatap.conf
service whatap-infra restart