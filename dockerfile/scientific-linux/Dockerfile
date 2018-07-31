FROM sl:7

## install EPL repo and last update
RUN yum -y install yum-conf-repo yum-conf-epel \
    && yum -y update

## add prerequistes packages for Shuttle
RUN yum -y install \
    curl \
    wget \
    unzip \
    gettext

# add posgress 9.5 client
# see https://yum.postgresql.org/repopackages.php#pg95
RUN  rpm -Uvh https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-sl95-9.5-3.noarch.rpm \
     && yum -y install postgresql95-contrib


# Add Tini
ARG TINI_VERSION="v0.17.0"
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini


#install OpenJDK
ENV JAVA_VERSION=8u181 \
    JAVA_RHEL_VERSION=1.8.0.181-3.b13
RUN yum -y install java-1.8.0-openjdk-devel-${JAVA_RHEL_VERSION}.el7_5.x86_64 


## postgresql-client-9.6  not available
 
 

# Add install TTF
RUN echo "#### Get Microsoft's Core Fonts" \
      && yum -y install curl cabextract xorg-x11-font-utils fontconfig \
      && rpm -i http://li.nux.ro/download/nux/dextop/el7/x86_64/webcore-fonts-3.0-1.noarch.rpm


##install FROM tomcat
ENV TOMCAT_MAJOR="8" \
    TOMCAT_VERSION="8.5.32" \
    CATALINA_HOME="/usr/local/tomcat"

ENV    TOMCAT_TGZ_URLS="https://www.apache.org/dyn/closer.cgi?action=download&filename=tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz"

##RUN groupadd tomcat \
##    && useradd -M -s /bin/nologin -g tomcat -d ${CATALINA_HOME} tomcat \
##    && cd /usr/local \
##    && wget -O apache-tomcat-${TOMCAT_VERSION}.tar.gz ${TOMCAT_TGZ_URLS} \
##    && tar -xzvf apache-tomcat-${TOMCAT_VERSION}.tar.gz \
##    && mv apache-tomcat-${TOMCAT_VERSION} tomcat \
##    && chown -hR tomcat:tomcat tomcat

RUN cd /usr/local \
    && wget -O apache-tomcat-${TOMCAT_VERSION}.tar.gz ${TOMCAT_TGZ_URLS} \
    && tar -xzvf apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    && mv apache-tomcat-${TOMCAT_VERSION} tomcat


RUN echo "#### Add catalina-jmx-remote.jar" \
    && curl -s -L  http://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/extras/catalina-jmx-remote.jar -o $CATALINA_HOME/lib/catalina-jmx-remote.jar



## install jdbc drivers

#### Download ORACLE JDBC drivers  - NEED AUTHENTICATE" 
# http://www.oracle.com/technetwork/database/features/jdbc/jdbc-drivers-12c-download-1958347.html
# wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn/utilities_drivers/jdbc/121010/ojdbc7.jar
# Add usr/local/drivers/jdbc for Oracle driver
COPY usr/local/drivers/jdbc/    /usr/local/drivers/jdbc/

# Install other jdbc drivers
RUN echo "#### Download  JDBC drivers for postgresql, mysql, MSSQL" \
    && mkdir -p /usr/local/drivers/jdbc \
    && curl -s -L https://jdbc.postgresql.org/download/postgresql-42.2.1.jar  -o  /usr/local/drivers/jdbc/postgresql-42.2.1.jar \
    && curl -s -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.45.tar.gz -o /tmp/mysql-connector-java-5.1.45.tar.gz \
    && tar -zxvf /tmp/mysql-connector-java-5.1.45.tar.gz -C /tmp \
    && cp /tmp/mysql-connector-java-5.1.45/mysql-connector-java-5.1.45-bin.jar /usr/local/drivers/jdbc \
    && curl -s -L https://download.microsoft.com/download/0/2/A/02AAE597-3865-456C-AE7F-613F99F850A8/sqljdbc_6.0.8112.200_enu.tar.gz -o /tmp/sqljdbc_6.0.8112.200_enu.tar.gz \
    && tar -zxvf /tmp/sqljdbc_6.0.8112.200_enu.tar.gz  -C /tmp \
    && cp /tmp/sqljdbc_6.0/enu/jre8/sqljdbc42.jar /usr/local/drivers/jdbc \
    && rm -rf /tmp/*

RUN echo "#### Symolic link on jdbc drivers for Shuttle" \
    && mkdir -p /usr/local/shuttle/drivers \
    && ln -s /usr/local/drivers/jdbc/mysql-connector-java-5.1.45-bin.jar /usr/local/shuttle/drivers/mysql.jar \
    && ln -s /usr/local/drivers/jdbc/postgresql-42.2.1.jar /usr/local/shuttle/drivers/postgresql.jar \
    && ln -s /usr/local/drivers/jdbc/sqljdbc42.jar /usr/local/shuttle/drivers/mssql.jar \
    && ln -s /usr/local/drivers/jdbc/ojdbc7.jar /usr/local/shuttle/drivers/oracle.jar


RUN echo "#### Download sqlline 1.2.0 for https://github.com/julianhyde/sqlline and Make symbolic  on jdbc drivers for sqlline " \
    && mkdir -p /usr/local/sqlline \
    && curl -s -L https://repo1.maven.org/maven2/sqlline/sqlline/1.2.0/sqlline-1.2.0-jar-with-dependencies.jar -o /usr/local/sqlline/sqlline-1.2.0-jar-with-dependencies.jar \
    && ln -s /usr/local/drivers/jdbc/mysql-connector-java-5.1.45-bin.jar  /usr/local/sqlline/mysql.jar \
    && ln -s /usr/local/drivers/jdbc/postgresql-42.2.1.jar /usr/local/sqlline/postgresql.jar  \
    && ln -s /usr/local/drivers/jdbc/sqljdbc42.jar /usr/local/sqlline/mssql.jar \
    && ln -s /usr/local/drivers/jdbc/ojdbc7.jar /usr/local/sqlline/oracle.jar


## install Shuttle

# test mandatory args
ARG RELEASE_MAJOR
ARG RELEASE_MINOR
ARG SHUTTLE_RELEASE
ARG SHUTTLE_INSTALLER_RELEASE

RUN [ -n "${SHUTTLE_RELEASE}" ] && [ -n "${RELEASE_MAJOR}" ] && [ -n "${RELEASE_MINOR}" ]


ENV SHUTTLE_INSTALLER_RELEASE=${SHUTTLE_INSTALLER_RELEASE}
ENV SHUTTLE_RELEASE=${SHUTTLE_RELEASE}



# Download Shuttle Packages
RUN mkdir -p /usr/local/shuttle/installer          \
    && mkdir -p /usr/local/shuttle/documentation   \
    && mkdir -p /usr/local/shuttle/patches/client  \
    && mkdir -p /usr/local/shuttle/patches/server  \
    && mkdir -p /usr/local/shuttle/patches/module  \
    && mkdir -p /usr/local/shuttle/patches/class

# Image Label
LABEL maintainer="kShuttle" \
      website="https://www.kshuttle.io" \
      description="Business Management Platform" \
      release="${SHUTTLE_RELEASE}" 



# Add bin
COPY bin/ /usr/local/shuttle/bin/

# Readme
##COPY USAGE.md /usr/local/shuttle/

# change log of the image or shuttle
##COPY releases/${RELEASE_MAJOR}.${RELEASE_MINOR}/CHANGELOG.md /usr/local/shuttle/

# Add Shuttle autoinstall response files
COPY autoinstall/ /usr/local/shuttle/autoinstall/

# Add Documentation
COPY packages/documentation/     /usr/local/shuttle/documentation/


# Add installer
COPY  packages/installer/ShuttleInstaller-${SHUTTLE_INSTALLER_RELEASE}.jar        /usr/local/shuttle/installer/ShuttleInstaller.jar

# Add Patches
COPY  packages/patches/  /usr/local/shuttle/patches/


# Copy template server.xml.dit template according to the release of tomcat to force external url
COPY usr/local/tomcat/ /usr/local/shuttle/tomcat/


ENV PATH=/usr/local/shuttle/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    CATALINA_OPTS="-Xms512m -Xmx8192m -Dfile.encoding=UTF-8 -Djava.awt.headless=true" \
    DATA_FOLDER=/data \
    DB_MAX_WAIT=30 \
    DB_HOST=db \
    DB_PORT=5432 \
    DB_TYPE=postgres \
    DB_CREATE_USER=true \
    DB_SYSTEM_USER=postgres \
    DB_SYSTEM_PASSWORD=yoursecretpassword \
    DB_SHUTTLE_REPO=SHUT_REPO \
    DB_SHUTTLE_USER=shuttle \
    DB_SHUTTLE_PASSWORD=password \
    DB_INSTANCE=ORCLCDB \
    WEBAPP_NAME=Shuttles \
    DEFAULT_CONNEXION_NAME=Default \
    EXTERNAL_URL_PROTOCOL=http \
    EXTERNAL_URL_PORT=8080 \
    EXTERNAL_URL_SERVER=localhost \
    KERBEROS_ENABLE=false \
    PROXY_ENABLE=true \
    PROXY_USE_CREDENTIALS=true \
    PROXY_USE_SHUTTLE_CREDENTIALS=false \
    PROXY_USE_DEFAULT_CONFIG=true \
    PROXY_HOST="" \
    PROXY_PORT="0" \
    PROXY_USER="" \
    PROXY_PASSWORD="" \
    JAXWS_ENABLE_MTOM=false \
    FORCE_INSTALL=false
 

 
# Metadata
EXPOSE 8080
VOLUME [ "${DATA_FOLDER}" ]


# Entrypoint and CMD
ENTRYPOINT ["/tini", "--", "bash", "/usr/local/shuttle/bin/entrypoint.sh" ]
CMD ["--help"]

