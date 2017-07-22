#!/bin/bash

NAME='replaceme' #GET THIS FROM MAIN SCRIPT
DIR=/home/'replaceme'/jc3mp/'$NAME' #GET USERNAME FROM MAIN SCRIPT!
LOG_FILE="$NAME.log"
CONSOLE_LOG="logs/console.log"
PID_FILE="$NAME.pid"
CMD="./Server"

function startnotification {
VAR=`ps -ef | grep "$DIR$CMD" | grep -v grep | wc -l`
if [ $VAR -gt 0 ]; then
echo "$NAME already running..."
else
rm -f $DIR$PID_FILE
PIDSV=0
PPIDSH=0
echo $(date +"%T-%d\%m\%Y") >> $DIR$LOG_FILE
echo "$NAME not running..."
echo "$DIR ... $PID_FILE" >> $DIR$LOG_FILE
screen -dm sh -c 'echo $$ > '$DIR$PID_FILE' ; cd '$DIR' ; $CMD | tee -a '$DIR$CONSOLE_LOG
while [ ! -s $DIR$PID_FILE ]; do sleep 1; done
PPIDSH=`cat $DIR$PID_FILE`
echo "PPID is $PPIDSH" >> $DIR$LOG_FILE
PIDSV=$(pgrep -P $PPIDSH -x Server)
echo "PID is $PIDSV" >> $DIR$LOG_FILE
echo $PIDSV > $DIR$PID_FILE
echo "$NAME listener is started..."
fi
}

function stopnotification {
kill `cat $DIR$NAME.pid`
rm -f $DIR$PID_FILE
echo "$NAME listener stopped."
}
case $1 in
start) startnotification;;
stop)  stopnotification;;
restart)
stopnotification
startnotification;;
*)
echo "usage: $NAME {start|stop}" ;;
esac
exit 0
}
