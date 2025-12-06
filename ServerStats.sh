#!/bin/bash
echo "SERVER PERFORMANCE STATS"

echo "CPU USAGE"
read cpu user nice system idle iowait irq softirq steal guest guest_nice <<< $(awk '/^cpu / {print $2, $3, $4, $5, $6, $7, $8, $9, $10}' /proc/stat)

total=$((user + nice + system + idle + iowait + irq + softirq + steal + guest + guest_nice))
used=$((total - idle))
cpu_usage=$(echo "scale=2; ($used * 100) / $total" | bc)

echo "CPU Usage: ${cpu_usage}%"
echo ""


echo  "MEMORY USAGE"

mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
mem_free=$(grep MemFree /proc/meminfo | awk '{print $2}')
mem_used=$((mem_total - mem_free))
mem_usage=$(echo "scale=2; ($mem_used * 100) / $mem_total" | bc)

echo "Total: $((mem_total / 1024)) MB"
echo "Used: $((mem_used / 1024)) MB (${mem_usage}%)"
echo "Free: $((mem_free / 1024)) MB"
echo ""

echo "DISK USAGE"

df -h | grep "^/dev/" | awk '{print $1, "Total:", $2, "Used:", $3, "Usage:", $5}'
echo ""

echo "TOP 5 PROCESSES BY CPU"

ps aux --sort=-%cpu | head -6 | tail -5 | awk '{printf "%-8s %-8s %6s  %s\n", $1, $2, $3"%", $11}'
echo ""

echo "TOP 5 PROCESSES BY MEMORY "
ps aux --sort=-%mem | head -6 | tail -5 | awk '{printf "%-8s %-8s %6s  %s\n", $1, $2, $4"%", $11}'
echo ""