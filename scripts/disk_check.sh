#!/bin/bash

# ================================================
# Disk Usage Checker
# Monitors disk space and alerts if threshold exceeded
# ================================================

# Source utilities and config

check_disk() {
    print_header "DISK USAGE CHECK"
    
    local overall_status=0
    local warnings=""
    
    log_info "Checking disk usage (threshold: ${DISK_THRESHOLD}%)..."
    echo ""
    
    # Header
    printf "%-20s %-10s %-10s %-10s %s\n" "PARTITION" "SIZE" "USED" "AVAILABLE" "STATUS"
    printf "%s\n" "$(printf '=%.0s' {1..70})"
    
    # Check each partition
    for partition in $DISK_PARTITIONS; do
        if [ ! -d "$partition" ]; then
            log_warning "Partition not found: $partition"
            continue
        fi
        
        local usage=$(df "$partition" | awk 'NR==2 {print $5}' | tr -d '%')
        local size=$(df -h "$partition" | awk 'NR==2 {print $2}')
        local used=$(df -h "$partition" | awk 'NR==2 {print $3}')
        local avail=$(df -h "$partition" | awk 'NR==2 {print $4}')
        
        if [ $usage -gt $DISK_THRESHOLD ]; then
            printf "${RED}%-20s %-10s %-10s %-10s %s${NC}\n" \
                "$partition" "$size" "$used" "$avail" "${usage}%"
            warnings="${warnings}${partition}: ${usage}% used\n"
            overall_status=1
        else
            printf "${GREEN}%-20s %-10s %-10s %-10s %s${NC}\n" \
                "$partition" "$size" "$used" "$avail" "${usage}%"
        fi
    done
    
    echo ""
    
    if [ $overall_status -eq 0 ]; then
        log_success "All partitions are healthy"
    else
        log_warning "Some partitions exceed threshold!"
        local hostname=$(hostname)
        send_alert "Disk Space Warning on $hostname" "$(echo -e $warnings)"
    fi
    
    return $overall_status
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    check_disk
    exit $?
fi
