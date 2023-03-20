#!/usr/bin/env sh

JAVA_OPTS="$JAVA_OPTS -Dspring-boot.run.profiles=mysql"


java $JAVA_OPTS -jar /app/petclinic/*.jar