#!/bin/bash

NAME='replaceme' #GET THIS FROM MAIN SCRIPT
DIR=/home/'replaceme'/jc3mp/'replaceme'  #GET USERNAME FROM MAIN SCRIPT!
MONITDIR="$DIR""monit/"
LOG_FILE="$NAME.log"
CONSOLE_LOG="logs/console.log"
PID_FILE="$NAME.pid"
CMD="./Server"

echo $MONITDIR

function startnotification {
VAR=`ps -ef | grep "$DIR$CMD" | grep -v grep | wc -l`
if [ $VAR -gt 0 ]; then
echo "$NAME already running..."
else
rm -f $MONITDIR$PID_FILE
PIDSV=0
PPIDSH=0
echo $(date +"%T-%d\%m\%Y") >> $MONITDIR$LOG_FILE
echo "$NAME not running..."
echo "$DIR ... $PID_FILE" >> $MONITDIR$LOG_FILE
echo "$MONITDIR$PID_FILE"
echo "LEL"
screen -dm sh -c 'echo $$ > '$MONITDIR$PID_FILE' ; cd '$DIR' ; $CMD | tee -a '$DIR$CONSOLE_LOG
while [ ! -s $MONITDIR$PID_FILE ]; do sleep 1; done
PPIDSH=`cat $MONITDIR$PID_FILE`
echo "PPID is $PPIDSH" >> $MONITDIR$LOG_FILE
PIDSV=$(pgrep -P $PPIDSH -x Server)
echo "PID is $PIDSV" >> $MONITDIR$LOG_FILE
echo $PIDSV > $MONITDIR$PID_FILE
echo "$NAME listener is started..."
fi
}

function stopnotification {
kill `cat $MONITDIR$NAME.pid`
rm -f $MONITDIR$PID_FILE
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
