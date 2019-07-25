#!/bin/bash
SERVICE_NAME=apollo-portal
## Adjust log dir if necessary
LOG_DIR=/opt/logs/100003173
## Adjust server port if necessary
SERVER_PORT=8070

## Adjust memory settings if necessary
export JAVA_OPTS="-server -Xms512m -Xmx512m -XX:CompressedClassSpaceSize=128m -XX:MetaspaceSize=200m -XX:MaxMetaspaceSize=200m"

## Only uncomment the following when you are using server jvm
#export JAVA_OPTS="$JAVA_OPTS -server -XX:-ReduceInitialCardMarks"

########### The following is the same for configservice, adminservice, portal ###########
export JAVA_OPTS="$JAVA_OPTS -Dserver.port=$SERVER_PORT -Dlogging.file=$LOG_DIR/$SERVICE_NAME.log -Xloggc:$LOG_DIR/gc.log -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=5M -XX:HeapDumpPath=$LOG_DIR/HeapDumpOnOutOfMemoryError/"

PATH_TO_JAR=$SERVICE_NAME".jar"
SERVER_URL="http://localhost:$SERVER_PORT"

function checkPidAlive {
    for i in `ls -t $SERVICE_NAME*.pid 2>/dev/null`
    do
        read pid < $i

        result=$(ps -p "$pid")
        if [ "$?" -eq 0 ]; then
            return 0
        else
            printf "\npid - $pid just quit unexpectedly, please check logs under $LOG_DIR and /tmp for more information!\n"
            exit 1;
        fi
    done

    printf "\nNo pid file found, startup may failed. Please check logs under $LOG_DIR and /tmp for more information!\n"
    exit 1;
}

if [ "$(uname)" == "Darwin" ]; then
    windows="0"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    windows="0"
elif [ "$(expr substr $(uname -s) 1 5)" == "MINGW" ]; then
    windows="1"
else
    windows="0"
fi

# for Windows
if [ "$windows" == "1" ] && [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]]; then
    tmp_java_home=`cygpath -sw "$JAVA_HOME"`
    export JAVA_HOME=`cygpath -u $tmp_java_home`
    echo "Windows new JAVA_HOME is: $JAVA_HOME"
fi

cd `dirname $0`/..

for i in `ls $SERVICE_NAME-*.jar 2>/dev/null`
do
    if [[ ! $i == *"-sources.jar" ]]
    then
        PATH_TO_JAR=$i
        break
    fi
done

if [[ ! -f PATH_TO_JAR && -d current ]]; then
    cd current
    for i in `ls $SERVICE_NAME-*.jar 2>/dev/null`
    do
        if [[ ! $i == *"-sources.jar" ]]
        then
            PATH_TO_JAR=$i
            break
        fi
    done
fi

if [[ -f $SERVICE_NAME".jar" ]]; then
  rm -rf $SERVICE_NAME".jar"
fi

printf "$(date) ==== Starting ==== \n"

ln $PATH_TO_JAR $SERVICE_NAME".jar"
chmod a+x $SERVICE_NAME".jar"
./$SERVICE_NAME".jar" start

rc=$?;

if [[ $rc != 0 ]];
then
    echo "$(date) Failed to start $SERVICE_NAME.jar, return code: $rc"
    exit $rc;
fi

declare -i counter=0
declare -i max_counter=48 # 48*5=240s
declare -i total_time=0

printf "Waiting for server startup"
until [[ (( counter -ge max_counter )) || "$(curl -X GET --silent --connect-timeout 1 --max-time 2 --head $SERVER_URL | grep "HTTP")" != "" ]];
do
    printf "."
    counter+=1
    sleep 5

    checkPidAlive
done

total_time=counter*5

if [[ (( counter -ge max_counter )) ]];
then
    printf "\n$(date) Server failed to start in $total_time seconds!\n"
    exit 1;
fi

printf "\n$(date) Server started in $total_time seconds!\n"

exit 0;
