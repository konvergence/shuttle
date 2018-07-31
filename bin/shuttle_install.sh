#!/usr/bin/env bash

# stop on first error
##set -e

source colorecho

[ ! -z $DEBUG  ] && set -x



[ -z "$DB_TYPE" ] && echo_red please define DB_TYPE && exit 1
[ -z "$DB_SYSTEM_USER" ] && echo_red please define DB_SYSTEM_USER &&  exit 1
[ -z "$DB_SYSTEM_PASSWORD" ] && echo_red please define DB_SYSTEM_PASSWORD &&  exit 1
[ -z "$DB_HOST" ] && echo_red please define DB_HOST && exit 1
[ -z "$DB_PORT" ] && echo_red please define DB_PORT && exit 1


[ -z "$DB_SHUTTLE_REPO" ] && echo_red please define DB_SHUTTLE_REPO && exit 1
[ -z "$DB_SHUTTLE_USER" ] && echo_red please define DB_SHUTTLE_USER && exit 1
[ -z "$DB_SHUTTLE_PASSWORD" ] && echo_red please define DB_SHUTTLE_PASSWORD && exit 1





#--------------------------------------------------------------------------------------------
usage() {
       echo "Usage: $0 [-f]" 1>&2;
       exit 1;
}



# monitor $logfile
monitor() {
    tail -F -n 0 $1 | while read line; do echo -e "$2: $line"; done
}




#--------------------------------------------------------------------------------------------
install_Shuttle() {
echo_yellow "start install  Shuttle ..."

    if [ ! -d $DATA_FOLDER/shuttle  ] || [ $force -eq 1 ]; then

    # Create shuttle data folder if needed
        if [ ! -d $DATA_FOLDER/shuttle ]; then 
            mkdir -p $DATA_FOLDER/shuttle
        fi
     
     #export CATALINA_BASE=${DATA_FOLDER}/shuttle/instance
    # copy tomcat instance folder
        if [ ! -d $CATALINA_BASE ]; then
            mkdir -p $CATALINA_BASE
            cp -r $CATALINA_HOME/conf $CATALINA_BASE
            cp -r $CATALINA_HOME/logs $CATALINA_BASE
            cp -r $CATALINA_HOME/temp $CATALINA_BASE
            cp -r $CATALINA_HOME/webapps $CATALINA_BASE
            cp -r $CATALINA_HOME/work $CATALINA_BASE
        fi

    # force attributs scheme,proxyName,proxyPort,secure on Connector if they are defined
     if [ ! -z "${EXTERNAL_URL_PROTOCOL}" ] && [ ! -z "${EXTERNAL_URL_PORT}" ] && [ ! -z "${EXTERNAL_URL_SERVER}" ] && [ ! -z "${CLIENT_USESSL}" ]; then
        envsubst < /usr/local/shuttle/tomcat/server.xml.dist > $CATALINA_BASE/conf/server.xml
     fi
     
 
    # REJECTED :::  change logging.properties from date rotate to size rotate
    ### cp /usr/local/shuttle/tomcat/logging-by-size.properties $CATALINA_BASE/conf/logging.properties

    # remove default webapps coming with tomcat
    # OpenVAS - Vulnerability Detection Method : Details: Apache Tomcat servlet/JSP container default files (OID: 1.3.6.1.4.1.25623.1.0.12085)
    rm -rf $CATALINA_BASE/webapps/*
    
    # copy driver folder into $DATA_FOLDER to allow update later
    if [ ! -d $DATA_FOLDER/shuttle/drivers  ]; then
       cp -r /usr/local/shuttle/drivers $DATA_FOLDER/shuttle/drivers
    else
       echo_yellow "update $DATA_FOLDER/shuttle/drivers with last jdbc drivers"
       cp -r /usr/local/shuttle/drivers/* $DATA_FOLDER/shuttle/drivers/
    fi

    # create schema / user for DB_TYPE if needed
        echo_green "create database and user if needed ..."
        ${DB_TYPE}_init.sh

    # if exist old xxx.WebServce or xxx.Updater under conf/Catalina, then remove them
     if [ -d $CATALINA_BASE/conf/Catalina/localhost ]; then
        rm -f $CATALINA_BASE/conf/Catalina/localhost/*.WebService.xml
        rm -f $CATALINA_BASE/conf/Catalina/localhost/*.Updater.xml
     fi
    
    # cause SHUTTLE-7997 : old module jar must be deleted before installer
    echo_yellow "remove old jar modules ..."
    for jarfile in $(find ${DATA_FOLDER}/shuttle/home/modules -name "*.jar"); do
        echo_yellow  "remove $jarfile"
        rm -f $jarfile
    done
    echo_green "done"
    

    
     # run shutlle installer
        echo_green "launch shuttle installer ..."
        envsubst < /usr/local/shuttle/autoinstall/${DB_TYPE}_autoinstall.xml > $DATA_FOLDER/shuttle/.autoinstall.xml
        ${JAVA_HOME}/bin/java -Dfile.encoding=UTF-8 -jar /usr/local/shuttle/installer/ShuttleInstaller.jar $DATA_FOLDER/shuttle/.autoinstall.xml
        echo_green "done"

       # force enable-mtom according to the variable {JAXWS_ENABLE_MTOM}
        envsubst < /usr/local/shuttle/tomcat/sun-jaxws.xml.dist > ${DATA_FOLDER}/shuttle/home/war/${WEBAPP_NAME}.WebService/WEB-INF/sun-jaxws.xml
        
    else
        echo_red "Shuttle is ever installed. You can use -f option to force"
        exit 1
    fi


}


#--------------------------------------------------------------------------------------------
patch_shuttle_client() {

    echo_yellow "start patching for client  ..."



    if [ ! -d $DATA_FOLDER/shuttle  ]; then
        echo_red "Shuttle is not configured. "
        return 1
    fi
    
    # Auto update Shuttle Client un needed
    if [ -f /usr/local/shuttle/patches/client/ShuttleClientUpdater.jar  ]; then

        envsubst < /usr/local/shuttle/autoinstall/client_autoupdate.xml > /tmp/client_autoupdate.xml
        ${JAVA_HOME}/bin/java -jar /usr/local/shuttle/patches/client/ShuttleClientUpdater.jar /tmp/client_autoupdate.xml
    else
      echo "no patches client"
    fi
    echo_green "done"

}        
#--------------------------------------------------------------------------------------------
patch_shuttle_server() {

echo_yellow "start patching for server  ..."

    if [ ! -d $DATA_FOLDER/shuttle  ]; then
        echo_red "Shuttle is not configured. "
        return 1
    fi
    
    # create patches_rollback
    if [ ! -d $DATA_FOLDER/shuttle/patches_rollback ]; then 
            mkdir -p $DATA_FOLDER/shuttle/patches_rollback
    fi


    #Convert string  ${SHUTTLE_RELEASE} to array
    # Exemple Regexp for 4.6.1:      ^(shuttle-.*-4\.6\.1)\.([0-9]+)\.jar$
    IFS='.'; read -ra RELEASE_PART <<< "${SHUTTLE_RELEASE}"   
    REGEXP='^(shuttle-.*-'${RELEASE_PART[0]}'\.'${RELEASE_PART[1]}'\.'${RELEASE_PART[2]}')\.([0-9]+)\.jar$'
    unset IFS
        
    # Update Server patches
        for f in /usr/local/shuttle/patches/server/*.jar; do
          b=$(basename $f)

          if [[ "$b" =~ ${REGEXP} ]]; then 
            r=${BASH_REMATCH[1]}
            
            # rollback patches
            echo_yellow apply new server patch $b

            for jarfile in $(find ${DATA_FOLDER}/shuttle/home/war -name "$r*.jar"); do
                d=$(dirname $jarfile)
                echo replace $jarfile
                mv $jarfile ${DATA_FOLDER}/shuttle/patches_rollback
                cp $f $d
            done

          else 
            echo "no patches server"
          fi 
       done

    echo_green "done"
}


#--------------------------------------------------------------------------------------------
patch_shuttle_modules() {

echo_yellow "start patching for modules  ..."

    if [ ! -d $DATA_FOLDER/shuttle  ]; then
        echo_red "Shuttle is not configured. "
        return 1
    fi
    
    # create patches_rollback
    if [ ! -d $DATA_FOLDER/shuttle/patches_rollback ]; then 
            mkdir -p $DATA_FOLDER/shuttle/patches_rollback
    fi

    

    #Convert string  ${SHUTTLE_RELEASE} to array
    # Exemple Regexp for 4.7.0:      ^(Plugin.*-4\.7\.0)\.([0-9]+)\.jar$
    # Plugin.ManageDatamartObjects-4.7.0.28000.jar 
    IFS='.'; read -ra RELEASE_PART <<< "${SHUTTLE_RELEASE}"   
    REGEXP='^(Plugin.*)-'${RELEASE_PART[0]}'\.'${RELEASE_PART[1]}'\.'${RELEASE_PART[2]}'\.([0-9]+)\.jar$'
    unset IFS
        
    # Update plugin patches
        for f in /usr/local/shuttle/patches/module/*.jar; do
          b=$(basename $f)

          if [[ "$b" =~ ${REGEXP} ]]; then 
            r=${BASH_REMATCH[1]}

            # seach if there is previous patched jar to replace
            for jarfile in $(find ${DATA_FOLDER}/shuttle/home/modules -name "$r*.jar"); do
                d=$(dirname $jarfile)
                echo backup previous plugin  $jarfile into ${DATA_FOLDER}/shuttle/patches_rollback
                mv $jarfile ${DATA_FOLDER}/shuttle/patches_rollback
            done
            
            # copy new plugin
            if [ ! -z "$jarfile" ] ; then
                 echo apply new plugin patch $b into $d
                cp $f  $d
            else
                echo_green "can not find exiting jar into ${DATA_FOLDER}/shuttle/home/modules to be replace by the new patch $b"
            fi
          else 
            echo "no patches modules"
          fi 
       done
    
    # Clean tomcat Cache

    echo_green "done"
}




#--------------------------------------------------------------------------------------------
patch_shuttle_classes() {

echo_yellow "start patching for classes  ..."

    if [ ! -d $DATA_FOLDER/shuttle  ]; then
        echo_red "Shuttle is not configured. "
        return 1
    fi
    
    # create patches_rollback
    if [ ! -d $DATA_FOLDER/shuttle/patches_rollback ]; then 
            mkdir -p $DATA_FOLDER/shuttle/patches_rollback
    fi


    REGEXP='^([^\*]+)\.class$'
        
    # Update plugin patches
        for f in /usr/local/shuttle/patches/class/*.class; do
          b=$(basename $f)

          if [[ "$b" =~ ${REGEXP} ]]; then 
            r=${BASH_REMATCH[1]}

            # seach if there is previous patched jar to replace
            for class in $(find ${DATA_FOLDER}/shuttle/home/war -name "$r*.class"); do
                d=$(dirname $class)
                echo backup previous class  $class into ${DATA_FOLDER}/shuttle/patches_rollback
                mv $class ${DATA_FOLDER}/shuttle/patches_rollback
            done
            
            # copy new class
            if [ ! -z "$class" ] ; then
                 echo apply new class patch $b into $d
                cp $f  $d
            else
                echo_green "can not find exiting class into ${DATA_FOLDER}/shuttle/home/war to be replace by the new patch $b"
            fi
          else 
            echo "no patches classes"
          fi 
       done
    
    # Clean tomcat Cache

    echo_green "done"
}

#--------------------------------------------------------------------------------------------
clean_tomcat_cache() {
    echo_yellow "clean tomcat cache ..."
    rm -rf $CATALINA_BASE/work/*
     echo_green "done"
}



#--------------------------------------------------------------------------------------------
# main
#--------------------------------------------------------------------------------------------
force=0
while getopts "f" opt; do
         case $opt in
             f)
                force=1
                ;;
             *)
               usage
               ;;
         esac
done

shift $((OPTIND-1))


#if [ $# -eq 0 ]; then
#   usage
#   exit 1
#fi

install_Shuttle 
patch_shuttle_client
patch_shuttle_server
patch_shuttle_modules
patch_shuttle_classes
clean_tomcat_cache



# mark current release
echo -n $SHUTTLE_RELEASE >$DATA_FOLDER/shuttle/RELEASE