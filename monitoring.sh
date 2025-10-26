#!/bin/bash

LOG_DIR="var/log/leaks_test"
REPORT_DIR="$LOG_DIR/reports"

mkdir -p $LOG_DIR $REPORT_DIR
chmod +x ./get_stats.sh

for ((i=1; i<5; i++))
do
TIME=$(date +"%Y%m%d_%H%M%S")
CUR_REPORT="$REPORT_DIR/system_report_$TIME.txt"
./get_stats.sh $CUR_REPORT
cat $CUR_REPORT
sleep 300
done
