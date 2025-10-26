#!/bin/bash

REPORT=$1

get_memory_stat() {
	echo "=== MEMORY STAT ===" >> $REPORT
	echo "---Usual:" >> $REPORT
	free -h >> $REPORT
	echo "" >> $REPORT
	
	echo "---Detailed:" >> $REPORT
	cat /proc/meminfo | grep -E "(MemTotal|MemFree|MemAvailible|SwapTotal|SwapFree|SwapCached)" >> $REPORT
	echo "" >> $REPORT
}

get_cpu_stat() {
	echo "=== CPU STAT ===" >> $REPORT
	echo "---Load:" >> $REPORT
	echo "CPU Load (1, 5, 15 min): $(uptime | awk -F'load average:' '{print $2}')" >> $REPORT
	echo "" >> $REPORT
	
	echo "---Top processes:" >> $REPORT
	ps aux --sort=-%cpu | head -5 >> $REPORT
	echo "" >> $REPORT
	
	echo "---Statisctics:" >> $REPORT
	mpstat 1 1 >> $REPORT
	echo "" >> $REPORT
}

get_swap_stat() {
	echo "=== SWAP STAT ===" >> $REPORT
	echo "---Inforamation:" >> $REPORT
	swapon --show >> $REPORT
	echo "" >> $REPORT
	
	echo "---Activity:" >> $REPORT
	vmstat 1 3 >> $REPORT
	echo "" >> $REPORT
}

get_critical_events() {
	echo "=== CRITICAL EVENTS ===" >> $REPORT
	echo "---emerg/alert/crit events in syslog:" >> $REPORT
	grep -E "emerg/alert/crit" /var/log/syslog | tail -20  >> $REPORT || echo "None" >> $REPORT
	echo "" >> $REPORT
	
	echo "---error events in syslog:" >> $REPORT
	grep "error" /var/log/syslog | grep -v "DEBUG\|INFO" | tail -15 >> $REPORT || echo "None"
	echo "" >> $REPORT
	
	echo "--emerg/alert/crit events (journalctl):" >> $REPORT
	journalctl -p emerg..crit --since "1 hour ago" >> $REPORT || echo "None" >> $REPORT
	echo "" >> $REPORT
	
	echo "---error events (journalctl):" >> $REPORT
	journalctl -p err --since "1 hour ago" >> $REPORT || echo "None" >> $REPORT
	echo "" >> $REPORT
}

get_kernel_stat() {
	echo "=== KERNEL EVENTS ===" >> $REPORT
	echo "---OOM killer events:" >> $REPORT
	dmesg -T | grep -i "oom\|our of memory" | tail -20 >> $REPORT || echo "None" >> $REPORT
	echo "" >> $REPORT
	
	echo "---Kernel panic and critical errors" >> $REPORT
	dmesg -T | grep -i "panic\|bug\|error\|warning" | grep -v "DEBUG\|INFO" | tail -15 >> $REPORT || echo "None" >> $REPORT
	echo "" >> $REPORT
	
	echo "---Recent kernel messages (dmesg):" >> $REPORT
	dmesg -T | tail -30 >> $REPORT || echo "None" >> $REPORT
	echo "" >> $REPORT
	
	echo "---Killed processes (potential OOM victims):" >> $REPORT
	ps -eo pid,ppid,comm,state,lstart,time --no-headers | grep -E "^[ ]*[0-9]+[ ]+[0-9]+[ ]+.*[ ]+Z[ ]+" >> $REPORT || echo "None" >> $REPORT
	echo "" >> $REPORT
}


get_memory_stat
get_cpu_stat
get_swap_stat
get_critical_events
get_kernel_stat

