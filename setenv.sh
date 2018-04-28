#!/bin/sh
CATALINA_OPTS="-Xms1024m -Xmx4096m -Xss1024K -XX:PermSize=512m -XX:MaxPermSize=2048m -Duser.timezone=Asia/Shanghai -Dspring.profiles.active=${ENV}"
