FROM ubuntu:16.04

# Configure timezone and locale
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

COPY sources.list /etc/apt/

RUN apt-get update \
    && apt-get -y --no-install-recommends --no-install-suggests install \
    locales \
    wget \
    tzdata \
    vim

ENV TOMCAT_VERSION 8.5.30
ENV TOMCAT_TGZ_URL http://mirrors.hust.edu.cn/apache/tomcat/tomcat-8/v8.5.30//bin/apache-tomcat-8.5.30.tar.gz

# Set locales & ENV
RUN locale-gen zh_CN.UTF-8
ENV LANG zh_CN.UTF-8
ENV LC_CTYPE zh_CN.UTF-8
ENV ENV development 


# Install openjdk-jre-8
RUN apt-get install -y \
    openjdk-8-jre \
    openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/openjdk-8-jre

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin
ENV TERM xterm
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# Add Tomcat
RUN wget -O tomcat.tar.gz $TOMCAT_TGZ_URL \
    && tar -xvf tomcat.tar.gz --strip-components=1\
    && rm tomcat.tar.gz 

ADD setenv.sh $CATALINA_HOME/bin/
COPY server.xml $CATALINA_HOME/conf/

#clean up
RUN apt-get autoremove \
    && dpkg --get-selections | awk '{print $1}' | cut -d: -f1 | grep -- '-dev$' | xargs apt-get remove -y \
    && rm -rf /usr/src \
    && apt-get clean all \
    && rm -rf /tmp/*

VOLUME "${CATALINA_HOME}/webapps"

EXPOSE 8080

# Launch Tomcat
CMD ["catalina.sh", "run"]
