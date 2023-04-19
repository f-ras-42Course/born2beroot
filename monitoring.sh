# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    monitoring.sh                                      :+:    :+:             #
#                                                      +:+                     #
#    By: fras <fras@student.codam.nl>                 +#+                      #
#                                                    +#+                       #
#    Created: 2023/04/08 12:01:12 by fras          #+#    #+#                  #
#    Updated: 2023/04/19 22:09:22 by fras          ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

#!/bin/bash
arc=$(uname --all)
p_cpu=$(cat /proc/cpuinfo | grep "physical id" | wc -l)
v_cpu=$(cat /proc/cpuinfo | grep "processor" | wc -l)
mem_use=$(free -m | awk 'NR==2 {printf "%s/%sMB (%.2f%%)", $3, $2, $3/$2*100}')
disk_use=$(df -h | awk '$NF=="/"{printf "%d/%dGb (%s)", $3, $2, $5}')
cpu_use=$(top -bn1 | grep "load" | awk '{printf "%.1f%%", $(NF-2)}')
last_boot=$(who -b | awk '{print $(NF-1), $NF}')
lvm_check=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi)
active_connections=$(ss -neopt state established | wc -l)
active_users=$(users | wc -w)
ip_address=$(hostname -I | sed 's/ //')
mac_address=$(ip link | grep "link/ether" | awk '{print $2}')
number_sudo_executes=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "  #Architecture: $arc
        #CPU physical : $p_cpu
        #vCPU : $v_cpu
        #Memory Usage: $mem_use
        #Disk Usage: $disk_use
        #CPU load: $cpu_use
        #Last boot: $last_boot
        #LVM use: $lvm_check
        #Connections TCP: $active_connections ESTABLISHED
        #User log: $active_users
        #Network: IP $ip_address ($mac_address)
        #Sudo: $number_sudo_executes cmd"