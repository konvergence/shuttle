#!/bin/bash
# sqlline - Script to launch SQL shell on Unix, Linux or Mac OS

BINPATH=/usr/local/sqlline:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext
exec java -Djava.ext.dirs=$BINPATH sqlline.SqlLine "$@"

# End sqlline